require 'test_helper'
include Devise::TestHelpers

class HomeControllerTest < ActionController::TestCase

  setup  do
    dump_database
    collection_fixtures 'users'
    @admin = User.where({email: 'admin@test.com'}).first
    @user = User.where({email: 'noadmin@test.com'}).first
  end
    
  test "user can change reporting period" do
    sign_in @user
    time = Time.gm(2015,5,1).to_i
    post "set_reporting_period", username: @user.username, effective_date: '05/01/2015'
    assert_response :success
  end
  
  test "default effective date for new user" do
    sign_in @admin
    time = Time.gm(2013,12,31).to_i
    user = User.new    
    assert_equal time, user.effective_date  
  end
end
