
# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  # API clients (curl, iOS) do NOT send CSRF tokens, so skip this.
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

  # If you want to be explicit, you can also null out the session:
  # protect_from_forgery with: :null_session

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    respond_with(resource)
  end

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
      # JWT is already in Authorization header via devise-jwt
    }, status: :ok
  end

  def respond_to_on_destroy
    head :no_content
  end
end

