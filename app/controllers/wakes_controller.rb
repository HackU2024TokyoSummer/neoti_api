require 'time'


class WakesController < ApplicationController
  skip_before_action :verify_token
  def index
    user = User.find_by(email: params[:email])
    wakes = Wake.where(user_id: user.id, neoti: false).where('wake_time > ?', Time.current)

    puts wakes

    render json: wakes.as_json, status: :ok
  end
  def create
    user = User.find_by(email: params[:email])
    Time.zone = 'Tokyo'

    # 文字列をDateTimeオブジェクトに変換し、JSTに設定
    time = Time.zone.parse(params[:wake_time])
    wake = Wake.create!(wake_time: time, user_id: user.id, billing: params[:billing])
    render json: wake, status: :ok
  end

  def past
    user = User.find_by(email: params[:email])
    total_money = Wake.where(user_id: user.id, neoti: true).where('wake_time < ?', Time.current).sum(:billing)
    history = Wake.where(user_id: user.id, neoti: true).where('wake_time < ?', Time.current)


    render json: {
      total_money: total_money,
      history: history.as_json(only: [:id, :wake_time, :billing])
    }, status: :ok

  end

  def neoti
    user = User.find_by(email: params[:email])
    res = Wake.where(user_id: user.id).update!(neoti: true)

    render json: res, status: :ok
  end
end

