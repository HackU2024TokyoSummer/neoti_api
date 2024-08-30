class UsersController < ApplicationController
  skip_before_action :verify_token, only: [:create]
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authorize, except: [:create]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    @user.jti = SecureRandom.uuid
    if @user.save
      token = generate_token(@user)
      render json: { message: 'User created successfully', user: @user.as_json, token: token }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user == current_user && @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @user == current_user
      @user.destroy
      render json: { message: 'User deleted successfully' }, status: :ok
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

  def generate_token(user)
    payload = {
      user_id: user.id,
      jti: user.jti,
      exp: 1.day.from_now.to_i
    }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end
end