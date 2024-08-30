class ApplicationController < ActionController::Base
  # before_action :verify_token

  private

  def verify_token
    token = request.headers['Authorization']&.split(' ')&.last

    Rails.logger.debug "Authorization Header: #{request.headers['Authorization']}"
    Rails.logger.debug "Extracted Token: #{token}"

    unless token.present?
      Rails.logger.warn "Token is missing"
      render json: { error: 'Authorization header is missing' }, status: :unauthorized
      return
    end

    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0]
      Rails.logger.debug "Decoded Token: #{decoded}"

      # expが切れているかチェック
      if decoded['exp'].nil? || Time.at(decoded['exp']) < Time.now
        Rails.logger.warn "Token has expired"
        render json: { error: 'Token has expired' }, status: :unauthorized
        return
      end

      # userが存在するかチェック
      @current_user = User.find(decoded['user_id'])
      Rails.logger.debug "Current User: #{@current_user.id}"

      # jtiが有効かチェック
      unless decoded['jti'] == @current_user.jti
        Rails.logger.warn "Invalid JTI"
        render json: { error: 'Invalid token' }, status: :unauthorized
        return
      end
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      Rails.logger.error "Token verification error: #{e.message}"
      render json: { error: e.message }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end

  def logged_in?
    !!current_user
  end

  def authorize
    unless logged_in?
      Rails.logger.warn "User not logged in"
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end
end
