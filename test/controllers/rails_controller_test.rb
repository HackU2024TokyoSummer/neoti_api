require "test_helper"

class RailsControllerTest < ActionDispatch::IntegrationTest
  test "should get db:migrate:status" do
    get rails_db:migrate:status_url
    assert_response :success
  end
end
