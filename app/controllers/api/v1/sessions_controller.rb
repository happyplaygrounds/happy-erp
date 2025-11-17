class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  # 🔑 API clients don’t send CSRF tokens → skip this check here
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]

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

