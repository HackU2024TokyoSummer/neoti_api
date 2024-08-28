class WakesController < ApplicationController

  def index
    wakes = @current_user.wakes.where()

    render json: wakes.as_json(only: [:id, :wake_time])
  end
  def create
    wake = Wake.create!(wake_time: params[:wake_time], user_id: @current_user.id)

    render json: wake, status: :ok
  end
end
