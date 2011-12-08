require 'test_helper'
include Devise::TestHelpers

class LogsControllerTest < ActionController::TestCase

  setup do
    dump_database
    
    @user = Factory(:user, admin: true)
    sign_in @user

  end

  test "GET 'index'" do
    get :index
    assert_response :success
  end

end
