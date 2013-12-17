require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup do
    dump_database

    @user = Factory(:user)
  end

  test "user should be found by username" do
    found_user = User.by_username @user.username
    assert_equal @user, found_user
  end

  test "user should be found by email" do
    found_user = User.by_email @user.email
    assert_equal @user, found_user
  end

  test "user preferences: selected_measure_ids replaces null with empty arrays" do
    @user.preferences['selected_measure_ids'] = nil
    assert @user.save
    @user.reload
    assert_equal [], @user.preferences['selected_measure_ids']
  end

end
