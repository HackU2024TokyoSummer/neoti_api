require "test_helper"

class WakesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def index
    wakeHistories = Wake.where(user_id: current_user.id)
  end

  def create
    wake = Wake.new({
                      wake_time: params[:wake_time],
                      billing: params[:billing],
                      user_id: current_user.id
                    })
    wake.save
    render json: {status: 'OK'}
  end
end
