require 'test_helper'

class TeamsControllerTest < ActionController::TestCase
  
  setup do
    dump_database
    @user = Factory(:admin)
    sign_in @user
    @name = "team 1"
    @providers = FactoryGirl.create_list(:provider, 10)
  end
  
  test "index" do
    get(:index)
    assert_response :success
  end
  
  test "create without providers" do
    post :create, :team => {:name => @name}
    assert_response :found
    assert_equal 1, Team.count
    assert_not_nil Team.where(name: @name)
  end

end
