
class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json

  skip_forgery_protection

  # POST /api/v1/login
  def create
    email    = params.dig(:user, :email)
    password = params.dig(:user, :password)

    user = User.find_for_database_authentication(email: email)

    if user&.valid_password?(password)
      sign_in(resource_name, user)

      render json: {
        user: {
          id: user.id,
          email: user.email
        }
      }, status: :ok
    else
      render json: { error: "Invalid email or password" },
             status: :unauthorized
    end
  end

  # DELETE /api/v1/logout
  def destroy
    user = current_user
    sign_out(resource_name)
    render json: { message: "Logged out", user_id: user&.id }, status: :ok
  end
end

