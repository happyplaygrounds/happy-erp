
# app/services/kpi/alerts.rb
module Kpi
  class Alerts
    EXPIRING_VALIDITY_DAYS   = 30
    EXPIRING_WARNING_DAYS    = 7
    HIGH_VALUE_THRESHOLD     = 100_000.0
    STALE_DAYS               = 45
    LOW_MARGIN_THRESHOLD_PCT = 0.15

    def initialize(reference_date: Date.current)
      @reference_date = reference_date
    end

    def call
      [].tap do |alerts|
        add_alert(alerts, "expiring",           expiring_quotes_count)
        add_alert(alerts, "high_value_pending", high_value_pending_count)
        add_alert(alerts, "stale_pipeline",     stale_quotes_count)
        add_alert(alerts, "low_margin",         low_margin_quotes_count)
      end
    end

    private

    attr_reader :reference_date

    def add_alert(alerts, type, count)
      alerts << { type: type, count: count } if count.positive?
    end

    # ------------------------------------------
    # Base scopes for your data
    # ------------------------------------------
    #
    def base_quotes
      recent_range = (reference_date - 90.days)..reference_date

      HappyQuote
          .where(quote_date: recent_range)
          #.where.not(status: %w[canceled archived])
      end


    #def base_quotes
    #  #HappyQuote.active.where.not(status: %w[canceled archived])
    #  HappyQuote
    #end

    def open_quotes
      base_quotes.where(status: [nil, "", "draft", "open", "sent", "pending"])
    end

    # ------------------------------------------
    # Individual Alert Types
    # ------------------------------------------

    # 1. Quotes nearing expiration
    def expiring_quotes_count
      validity_days = EXPIRING_VALIDITY_DAYS
      warning_days  = EXPIRING_WARNING_DAYS

      expiry_start = reference_date - validity_days
      expiry_end   = expiry_start + warning_days

      open_quotes.where(quote_date: expiry_start..expiry_end).count
    end

    # 2. High-value quotes still open
    def high_value_pending_count
      open_quotes.where("total >= ?", HIGH_VALUE_THRESHOLD).count
    end

    # 3. Open quotes inactive too long
    def stale_quotes_count
      cutoff = reference_date - STALE_DAYS
      open_quotes.where("quote_date < ?", cutoff).count
    end

    # 4. Quotes with low margin %
    def low_margin_quotes_count
      lines = HappyQuoteLine
                .joins(:happy_quote)
                .merge(open_quotes)

      rev_by_quote = lines.group(:happy_quote_id).sum(:total_line_amount)
      cost_by_quote = lines.group(:happy_quote_id).sum(:total_cost_amount)

      low_ids = rev_by_quote.each_with_object([]) do |(quote_id, rev), result|
        rev = rev.to_f
        next unless rev > 0

        cost = cost_by_quote[quote_id].to_f
        margin_pct = (rev - cost) / rev

        result << quote_id if margin_pct < LOW_MARGIN_THRESHOLD_PCT
      end

      low_ids.size
    end
  end
end

