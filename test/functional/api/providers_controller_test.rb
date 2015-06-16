require 'test_helper'
include Devise::TestHelpers
  module Api
  class ProvidersControllerTest < ActionController::TestCase

    setup do
      dump_database
      collection_fixtures 'users', 'providers', 'measures', 'practices'
      @user = User.where({email: 'admin@test.com'}).first      
      @provider = Provider.where({family_name: "Darling"}).first
      
      @practice1 = Practice.first
      @practice2 = Practice.last
      
      @staff1 = User.where({email: 'noadmin@test.com'}).first   
      @staff2 = User.where({email: 'noadmin2@test.com'}).first
      
      @staff1.practice = @practice1
      @staff2.practice = @practice2
      @staff1.save!
      @staff2.save!
      
      #setup practice 1
      @provider1 = Provider.where({given_name: "William"}).first
      @pp1 = Provider.where('cda_identifiers.extension' => "Test Org").first
      @practice1.provider = @pp1
      @practice1.save!
      
      @provider1.parent = @pp1
      @provider1.save!
      
      #setup practice 2
      @provider2 = Provider.where({given_name: "Anthony"}).first
      @pp2 = Provider.where('cda_identifiers.extension' => "Test Org 2").first 
      @practice2.provider = @pp2
      @practice2.save!
      
      @provider2.parent = @pp2
      @provider2.save!
      
      @npi_user = User.where(username: 'npiuser2').first
      @npi_provider = Provider.by_npi(@npi_user.npi).first
      @npi_user.provider_id = @npi_provider.id
      @npi_provider.save!
      @npi_user.save!
      
      @npi_user2 = User.where(username: 'npiuser').first
    end

    test "get index" do
      sign_in @user 
      get :index
      assert_not_nil assigns[:providers]
    end

    test "new" do
      sign_in @user
      get :new, format: :json
      assert_response :success
    end

    test "get show js" do
      sign_in @user
      get :show, id: @provider.id, format: :json
      assert_not_nil assigns[:provider]
      assert_response :success
    end
    
    test "allow access to practice provider " do
      sign_in @staff1
      get :show, id: @provider1.id, format: :json
      assert_response :success
    end
    
    test "don't allow access to non practice provider " do
      sign_in @staff1
      APP_CONFIG['use_opml_structure'] = false
      get :show, id: @provider2.id, format: :json
      assert_response 403
      APP_CONFIG['use_opml_structure'] = true
    end
    
    test "allow access to practice npi provider assigned to user" do 
      APP_CONFIG['use_opml_structure'] = false
      sign_in @npi_user
      get :show, id: @npi_provider.id
      assert_response :success
      APP_CONFIG['use_opml_structure'] = true
    end

    test "do not allow access to practice provider not assigned to user" do 
      sign_in @npi_user2
      APP_CONFIG['use_opml_structure'] = false
      get :show, id: @npi_provider.id
      assert_response 403
      APP_CONFIG['use_opml_structure'] = true
    end


    test "update provider" do
      sign_in @user
      put :update, id: @provider.id, provider: @provider.attributes, format: :json
      assert_response :success
    end

    test "get index via API" do
      sign_in @user
      get :index, {format: :json}
      json = JSON.parse(response.body)
      assert_response :success
      assert_equal(true, json.first.respond_to?(:keys))
    end

    test "create via API" do
      sign_in @user
      provider = Provider.where({family_name: "Darling"}).first
      provider_attributes = provider.attributes
      provider_attributes.delete('_id')
      post :create, :provider => provider_attributes
      json = JSON.parse(response.body)
      assert_response :success
      assert_equal(true, json.respond_to?(:keys))
    end

  end
end
