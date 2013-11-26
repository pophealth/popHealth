require 'test_helper'
include Devise::TestHelpers
  module Api
  class ProvidersControllerTest < ActionController::TestCase

    setup do
      dump_database
      @user = Factory(:admin)
      @provider = Factory(:provider)
      @other_provider = Factory(:provider)
      collection_fixtures 'measures'
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
      provider = Factory(:provider)
      post :create, :provider => provider.attributes
      json = JSON.parse(response.body)
      assert_response :success
      assert_equal(true, json.respond_to?(:keys))
    end

  end
end
