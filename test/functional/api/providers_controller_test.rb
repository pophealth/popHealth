require 'test_helper'
include Devise::TestHelpers
  module Api
  class ProvidersControllerTest < ActionController::TestCase

    setup do
      dump_database
      collection_fixtures 'users', 'providers', 'measures'
      @user = User.where({email: 'admin@test.com'}).first
      @provider = Provider.where({family_name: "Darling"}).first
      
      @user.provider = @provider.id
      @user.save!
      sign_in @user
    end

    test "get index" do
      get :index
      assert_not_nil assigns[:providers]
    end

    test "new" do
      get :new, format: :json
      assert_response :success
    end

    test "get show js" do
      get :show, id: @provider.id, format: :json
      assert_not_nil assigns[:provider]
      assert_response :success
    end

    test "update provider" do
      put :update, id: @provider.id, provider: @provider.attributes, format: :json
      assert_response :success
    end

    test "get index via API" do
      get :index, {format: :json}
      json = JSON.parse(response.body)
      assert_response :success
      assert_equal(true, json.first.respond_to?(:keys))
    end

    test "create via API" do
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
