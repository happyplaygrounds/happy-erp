# app/controllers/api/v1/kpis_controller.rb
class Api::V1::KpisController < Api::V1::BaseController
  def overview
    data = Kpi::Overview.new.call
    render json: data
  end
end

