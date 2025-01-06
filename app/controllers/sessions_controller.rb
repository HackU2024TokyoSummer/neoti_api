class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params['email'])

    if user && user&.authenticate(params[:password])
      jti = user.jti
      exp = (Time.now + 1.hour).to_i
      payload = {jti: jti, user_id: user.id}
      token = JWT.encode(payload, Rails.application.secret_key_base)
    end
    render json: {token: token}
  end

  def delete
    @current_user.update(jti: SecureRandomaa.uuid)
    render json: {message: 'logout successfully.'}
  end
end
