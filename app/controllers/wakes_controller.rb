class WakesController < ApplicationController
  before_action :authorize
  def index
    user = User.find_by(email: params[:email])
    wakes = user.wakes

    render json: wakes.as_json(only: [:id, :wake_time, :billing])
  end
  def create
    user = User.find_by(email: params[:email])
    time = DateTime.parse(params[:wake_time])
    wake = Wake.create!(wake_time: time, user_id: user.id, billing: params[:billing])

    render json: wake, status: :ok
  end

  def past
    user = User.find_by(email: params[:email])
    total_money = Wake.where(user_id: user.id, neoti: true).sum(:billing)
    all_wakes = user.wakes.where(user_id: user.id)

    render json: [all_wakes, total_money].as_json, status: :ok
  end
end
