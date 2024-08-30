class WakesController < ApplicationController

  def index
    wakes = @current_user.wakes.where(waked: false)

    render json: wakes.as_json(only: [:id, :wake_time])
  end
  def create
    wake = Wake.create!(wake_time: params[:wake_time], user_id: @current_user.id, billing: params[:billing])

    render json: wake, status: :ok
  end

  def past
    total_money = Wake.where(user_id: current_user.id, neoti: true).sum(:billing)
  end
end
