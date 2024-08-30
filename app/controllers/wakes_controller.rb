class WakesController < ApplicationController
  before_action :authorize
  def index
    wakes = @current_user.wakes.where(waked: false)

    render json: wakes.as_json(only: [:id, :wake_time])
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
