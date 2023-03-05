require "test_helper"
  
class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  test "should get index" do
    sign_in users(:user1)
    get users_path
    assert_response :success
  end
end
