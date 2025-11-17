
# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  # 🚫 Disable CSRF checks entirely for this controller
  skip_forgery_protection

  # POST /api/v1/login
  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    respond_with(resource)
  end

  # DELETE /api/v1/logout
  def destroy
    sign_out(resource_name)
    respond_to_on_destroy
  end

  private

  def respond_with(resource, _opts = {})
    render json: {
      user: {
        id: resource.id,
        email: resource.email
      }
      # JWT is already added to the Authorization header by devise-jwt
    }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end

