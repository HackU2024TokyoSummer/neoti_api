class WakesController < ApplicationController
  before_action :authorize

  def index
    wakes = current_user.wakes.where(waked: false)
    render json: wakes.as_json(only: [:id, :wake_time, :billing])
  end

  def create
    time = DateTime.parse(params[:wake_time])
    wake = current_user.wakes.new(wake_time: time, billing: params[:billing])

    if wake.save
      render json: wake, status: :created
    else
      render json: { errors: wake.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    render json: { error: "Invalid date format: #{e.message}" }, status: :bad_request
  end

  def past
    total_money = current_user.wakes.where(neoti: true).sum(:billing)
    render json: { total_money: total_money }, status: :ok
  end
end
