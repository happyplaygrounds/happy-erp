# app/services/kpi/team_performance.rb
module Kpi
  class TeamPerformance
    def initialize(from:, to:)
      @from = from
      @to   = to
    end

    def call
      quotes = HappyQuote.active.where(quote_date: @from..@to)

      lines = HappyQuoteLine
        .joins(:happy_quote)
        .merge(quotes)

      revenue_by_quote = lines.group(:happy_quote_id).sum(:total_line_amount)
      cost_by_quote    = lines.group(:happy_quote_id).sum(:total_cost_amount)

      per_user = {}

      quotes.find_each do |q|
        key = q.user_name.presence || "Unknown"
        per_user[key] ||= {
          user_name: key,
          quotes_count: 0,
          quotes_value: 0.0,
          won_count: 0,
          revenue: 0.0,
          cost: 0.0
        }

        entry = per_user[key]
        entry[:quotes_count] += 1
        entry[:quotes_value] += q.total.to_f

        entry[:won_count] += 1 if q.won?

        rev = revenue_by_quote[q.id] || 0.0
        cst = cost_by_quote[q.id] || 0.0
        entry[:revenue] += rev.to_f
        entry[:cost]    += cst.to_f
      end

      per_user.values.map do |entry|
        margin = entry[:revenue] - entry[:cost]
        win_rate = if entry[:quotes_count].positive?
                     entry[:won_count].to_f / entry[:quotes_count]
                   else
                     0.0
                   end
        margin_pct = if entry[:revenue].positive?
                       margin / entry[:revenue]
                     else
                       0.0
                     end

        entry.merge(
          margin: margin,
          win_rate: win_rate,
          margin_pct: margin_pct
        )
      end
    end
  end
end

