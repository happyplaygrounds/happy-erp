
# app/controllers/api/v1/quotes_controller.rb
class Api::V1::QuotesController < Api::V1::BaseController
  def index
    quotes = base_scope
      .includes(:happy_customer)
      .order(quote_date: :desc)
      .limit(limit_param)

    render json: quotes.map { |q| quote_json(q) }
  end

  def show
    quote = HappyQuote.active.includes(:happy_customer, :happy_quote_lines).find(params[:id])

    render json: quote_json(quote).merge(
      lines: quote.happy_quote_lines.map { |line| quote_line_json(line) }
    )
  end

  private

  def base_scope
    scope = HappyQuote.active

    if params[:status].present?
      scope = scope.where(status: params[:status])
    end

    if params[:from].present? && params[:to].present?
      from = Date.parse(params[:from]) rescue nil
      to   = Date.parse(params[:to]) rescue nil
      scope = scope.where(quote_date: from..to) if from && to
    end

    scope
  end

  def limit_param
    [params[:limit].to_i.presence || 100, 500].min
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
      user_name: q.user_name
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
