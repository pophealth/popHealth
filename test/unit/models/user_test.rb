require 'test_helper'

class UserTest < ActiveSupport::TestCase
  include Devise::TestHelpers

  setup do
    dump_database
    collection_fixtures 'users'

    @user = User.where({email: 'noadmin@test.com'}).first
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

  test "user preferences: setting display provider tree" do
    @user.preferences['should_display_provider_tree'] = true
    assert @user.save
    @user.reload
    assert_equal true, @user.preferences['should_display_provider_tree']
  end
  
  test "user can change reporting period"
    sign_in @user
    time = Time.gm(2013,12,31)
    post "home/set_reporting_period", effective_date: time
    assert_response :success
    assert_equal @user.effective_date, time  
  end
  
  test "default effective date for new user"
    sign_in User.where({email: "admin@test.com"}).first
    time = Time.gm(2013,12,31)
    user = User.new    
    assert_equal time, user.effective_date  
  end
end
