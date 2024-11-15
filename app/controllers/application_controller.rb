class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  include Pundit::Authorization
  protect_from_forgery with: :exception

  rescue_from Pundit::NotAuthorizedError do
    redirect_to root_url, alert: 'You do not have access to this page'
  end

  add_flash_types :info, :error, :warning

end
