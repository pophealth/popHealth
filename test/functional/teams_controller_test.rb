require 'test_helper'
include Devise::TestHelpers
class TeamsControllerTest < ActionController::TestCase
  setup do
    dump_database
    collection_fixtures 'providers', 'teams', 'users'
   
    @no_staff_user = User.where({email: 'nostaff@test.com'}).first
    
    @team = Team.where("name" => "Team Test 1").first
    @provider = Provider.where({family_name: "Darling"}).first
    @team.providers << @provider._id
    @team.save!    
  
    @user = User.where({email: 'admin@test.com'}).first    
    @user.teams << @team   
    @user.save!
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
    assert_not_nil assigns(:teams)
  end

  test "should get new page" do
    sign_in @user
    get :new
    assert_response :success
  end

  test "should not get new page for non staff" do
    sign_in @no_staff_user
    get :new
    assert_response 403
  end

  test "should create team" do
    sign_in @user
    
    assert_difference('Team.count') do
      post :create, name: 'Test3', provider_ids: [@provider._id]
    end
    new_team = Team.where(:name => 'Test3').first
    assert new_team 
    assert_equal @provider.id.to_s, new_team.providers[0]
    assert_redirected_to new_team
  end

  test "should not create team for blank name" do
    sign_in @user
    assert_no_difference('Team.count') do
      post :create, name: '  ', provider_ids: [@provider._id]
    end
  end

  test "should not create team with no providers" do
    sign_in @user
    assert_no_difference('Team.count') do
      post :create, name: 'Test3', provider_ids: []
    end
  end

  test "should show team" do
    sign_in @user
    get :show, id: @team.id
    assert_response :success
  end

  test "should not show team for other user" do
    sign_in @no_staff_user
    get :show, id: @team.id
    assert_response 403
  end

  test "should get edit" do
    sign_in @user
    get :edit, id: @team.id
    assert_response :success
  end

  test "should not get edit for other user" do
    sign_in @no_staff_user
    get :edit, id: @team.id
    assert_response 403
  end

  test "should update team" do
    sign_in @user
    post :update, id: @team.id, name: @team.name, provider_ids: [@provider._id]
    assert_redirected_to team_path(assigns(:team))
  end

  test "should not update team for other user" do
    sign_in @no_staff_user
    post :update, id: @team.id, name: @team.name, provider_ids: [@provider._id]
    assert_response 403
  end

  test "should destroy team" do
    sign_in @user
    id = @team.id
    assert_difference('Team.count', -1) do
      delete :destroy, id: id
    end
    assert_redirected_to teams_path
  end

  test "should not destroy team for other user" do
    sign_in @no_staff_user
    id = @team.id
    assert_difference('Team.count', 0) do
      delete :destroy, id: id
    end
  end
end
