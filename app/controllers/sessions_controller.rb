class SessionsController < ApplicationController
  skip_before_action :verify_token, only: [:create]

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      user.update(jti: SecureRandom.uuid)
      token = generate_token(user)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    current_user.update(jti: SecureRandom.uuid)
    render json: { message: 'Logged out successfully' }, status: :ok
  end

  private

  def generate_token(user)
    payload = {
      user_id: user.id,
      jti: user.jti,
      exp: 1.day.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end