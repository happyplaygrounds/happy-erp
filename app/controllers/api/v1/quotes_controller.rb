# app/controllers/api/v1/quotes_controller.rb
#
module Api
  module V1
    class QuotesController < Api::V1::BaseController
      # GET /api/v1/quotes
      def index
        quotes = base_scope
          .includes(:happy_customer)
          .order(quote_date: :desc)
          .limit(limit_param)

        render json: quotes.map { |q| quote_json(q) }
      end

      # GET /api/v1/quotes/:id
      def show
        quote = base_scope
          .includes(:happy_customer, :happy_quote_lines)
          .find(params[:id])

        render json: quote_json(quote).merge(
          lines: quote.happy_quote_lines.map { |line| quote_line_json(line) }
        )
      end

      private

      def base_scope
        # if you want to ignore stale `active` and just filter by status, you can change this
        #HappyQuote.where.not(status: %w[canceled archived])
        HappyQuote
      end

      def limit_param
          limit = params[:limit].to_i
          limit = 100 if limit <= 0
          [limit, 500].min
      end


      def quote_json(q)
        {
          id: q.id,
          number: q.number,
          customer_name: q.happy_customer&.customer_name,
          total: q.total.to_f,
          status: q.status,
          state: q.state,
          quote_date: q.quote_date,
          estimated_delivery_date: q.estimated_delivery_date,
          user_name: q.user_name.presence || q.user&.email
        }
      end

      def quote_line_json(line)
        {
          id: line.id,
          description: line.description,
          quantity: line.quantity.to_f,
          unit_price: line.unit_price.to_f,
          total_line_amount: line.total_line_amount.to_f,
          total_cost_amount: line.total_cost_amount.to_f,
          margin: line.margin.to_f,
          vendor_name: line.vendor_name,
          status: line.status
        }
      end
    end
  end
end
