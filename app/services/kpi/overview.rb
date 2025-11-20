# app/services/kpi/overview.rb
module Kpi
  class Overview
    def initialize(reference_date: Date.current)
      @reference_date = reference_date
    end

    def call
      {
        today: period_stats(today_range),
        this_week: period_stats(week_range),
        this_month: period_stats(month_range),
        alerts: alerts
      }
    end

    private

    attr_reader :reference_date

    def base_scope
      HappyQuote.active
    end

    def today_range
      reference_date..reference_date
    end

    def week_range
      reference_date.beginning_of_week..reference_date.end_of_week
    end

    def month_range
      reference_date.beginning_of_month..reference_date.end_of_month
    end

    def period_stats(range)
      quotes = base_scope.where(quote_date: range)

      quotes_count = quotes.count
      quotes_value = quotes.sum(:total).to_f

      won_count = quotes.where(status: HappyQuote::WON_STATUSES).count

      win_rate = if quotes_count.positive?
                   won_count.to_f / quotes_count
                 else
                   0.0
                 end

      # Line-level revenue / cost / margin
      line_scope = HappyQuoteLine
        .joins(:happy_quote)
        .merge(quotes)

      revenue = line_scope.sum(:total_line_amount).to_f
      cost    = line_scope.sum(:total_cost_amount).to_f
      margin  = revenue - cost
      margin_pct = if revenue.positive?
                     margin / revenue
                   else
                     0.0
                   end

      {
        quotes_count: quotes_count,
        quotes_value: quotes_value,
        win_rate: win_rate,
        revenue: revenue,
        cost: cost,
        margin: margin,
        margin_pct: margin_pct
      }
    end

    def alerts
      Kpi::Alerts.new(reference_date: reference_date).call
    end


    def expiring_quotes_alert
      soon = reference_date..(reference_date + 7.days)
      count = base_scope
        .where(estimated_delivery_date: soon)
        .where(status: %w[open sent pending])
        .count

      return if count.zero?

      {
        type: "expiring",
        count: count
      }
    end

    def high_value_pending_alert
      threshold = 100_000 # adjust for your world
      count = base_scope
        .where(status: %w[open sent pending])
        .where("total >= ?", threshold)
        .count

      return if count.zero?

      {
        type: "high_value_pending",
        count: count
      }
    end
  end
end

