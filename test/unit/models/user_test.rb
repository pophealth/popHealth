require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  setup do
    dump_database
    
    @user = Factory(:user)
  end
  
  test "user should be found by username" do
    found_user = User.find_by_username @user.username
    assert_equal @user, found_user
  end
  
end
