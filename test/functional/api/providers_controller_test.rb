require 'test_helper'
include Devise::TestHelpers
  module Api
  class ProvidersControllerTest < ActionController::TestCase

    setup do
      dump_database
      collection_fixtures 'users', 'providers', 'measures'
      @user = User.where({email: 'admin@test.com'}).first
      @provider = Provider.where({family_name: "Darling"}).first
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
<<<<<<< HEAD
      provider = Provider.where({family_name: "Darling"}).first
=======
      provider = FactoryGirl.build(:provider)
>>>>>>> By running Factory(:provider), the entry is automatically committed to the database. This means that trying to take that opject and post it to the API causes an error since the row already exists in the database. By running FactoryGirl.build, we instead create an unsaved copy of the object and post that object instead.
      post :create, :provider => provider.attributes
      json = JSON.parse(response.body)
      assert_response :success
      assert_equal(true, json.respond_to?(:keys))
    end

  end
end
