require 'test_helper'
include Devise::TestHelpers

class LogsControllerTest < ActionController::TestCase

  setup do
    dump_database
    collection_fixtures 'users'

    @user = User.where({email: 'admin@test.com'}).first
    sign_in @user

  end

  test "GET 'index'" do
    get :index
    assert_response :success
  end

end
