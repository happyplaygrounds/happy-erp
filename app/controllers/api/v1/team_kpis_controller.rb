# app/controllers/api/v1/team_kpis_controller.rb
class Api::V1::TeamKpisController < Api::V1::BaseController
  def index
    from = params[:from].present? ? Date.parse(params[:from]) : Date.current.beginning_of_month
    to   = params[:to].present?   ? Date.parse(params[:to])   : Date.current.end_of_month

    data = Kpi::TeamPerformance.new(from: from, to: to).call
    render json: data
  end
end

