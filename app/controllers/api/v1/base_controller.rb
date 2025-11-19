# app/controllers/api/v1/base_controller.rb
class Api::V1::BaseController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :set_default_format

  # 👇 While testing: do NOT require login for API
  # (If ApplicationController has authenticate_user!, this will override it)
  skip_before_action :authenticate_user!, raise: false

  private

  def set_default_format
    request.format = :json
  end
end

