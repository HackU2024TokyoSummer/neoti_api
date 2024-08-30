class WakesController < ApplicationController
  before_action :authorize

  def index
    wakes = current_user.wakes.where(waked: false)
    render json: wakes.as_json(only: [:id, :wake_time, :billing])
  end

  def create
    Rails.logger.debug "Create action started"
    Rails.logger.debug "Current User: #{current_user.inspect}"
    Rails.logger.debug "Params: #{params.inspect}"

    wake_params = params.permit(:wake_time, :billing)
    time = wake_params[:wake_time].present? ? DateTime.parse(wake_params[:wake_time]) : DateTime.now
    wake = current_user.wakes.new(wake_time: time, billing: wake_params[:billing])

    if wake.save
      Rails.logger.debug "Wake saved successfully"
      render json: wake, status: :created
    else
      Rails.logger.warn "Wake save failed: #{wake.errors.full_messages}"
      render json: { errors: wake.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ArgumentError => e
    Rails.logger.error "Invalid date format: #{e.message}"
    render json: { error: "Invalid date format: #{e.message}" }, status: :bad_request
  rescue StandardError => e
    Rails.logger.error "Unexpected error in create action: #{e.message}"
    render json: { error: "An unexpected error occurred" }, status::internal_server_error
  end

  def past
    total_money = current_user.wakes.where(neoti: true).sum(:billing)
    render json: { total_money: total_money }, status: :ok
  end
end