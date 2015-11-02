require 'test_helper'
include Devise::TestHelpers
module Api
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
      @no_staff_user.save!
    end

    # index, show, team_providers

    test "show for team's owner" do
      sign_in @user
      get :show, :id=>@team.id
      assert_response :success
    end

    test "don't show for non-owner user" do
      sign_in @no_staff_user
      get :show, :id=> @team.id
      assert_response 403
    end

    test 'get index' do
      sign_in @user
      get :index
      teams = JSON.parse(response.body)
      assert_equal 1, teams.length
      assert_equal "Team Test 1", teams[0]["name"]
    end

    test 'access denied on index for non staff user' do
      sign_in @no_staff_user
      get :index
      assert_response 403
    end

    test 'get team providers' do
      sign_in @user
      get :team_providers, :id=> @team.id
      providers = JSON.parse(response.body) 
      assert_equal 1, providers.length
      assert_equal @provider.id.to_s, providers[0]["_id"]
    end
  end
end
