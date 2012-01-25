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
  
  test "create with providers" do
    post :create, {:team => {:name => @name}, :provider_ids => [@providers.map(&:id)]}
    assert_response :found
    assert_not_nil assigns(:providers)
    assert_equal @providers.size, Team.first.providers.size
  end
  
  test "update with providers" do
    new_provider = Factory(:provider)
    @team = Team.create(name: @name)
    new_provider_list = @providers[0..9] << new_provider
    put :update, {:id => @team.id, :provider_ids => new_provider_list.map(&:id)}
    assert_equal new_provider_list.size, Team.first.providers.size
  end
end
