class WakesController < ApplicationController
  skip_before_action :verify_token
  def index
    user = User.find_by(email: params[:email])
    wakes = Wake.where(user_id: user.id)

    puts wakes

    render json: wakes.as_json, status: :ok
  end
  def create
    time = DateTime.parse(params[:wake_time])
    wake = Wake.create!(wake_time: time, user_id: @current_user.id, billing: params[:billing])

    render json: wake, status: :ok
  end

  def past
    total_money = Wake.where(user_id: current_user.id, neoti: true).sum(:billing)
  end
end

