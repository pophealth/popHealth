require 'test_helper'

  module Api
  class PracticesControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup do
      dump_database
      collection_fixtures 'users', 'practices'
      @user = User.where({email: 'admin@test.com'}).first
      @practice = Practice.first
    end

    test "get practice index" do
      sign_in @user
      get :index
      assert_response :success
    end

    test "get practice information" do
      sign_in @user
      get :show, id: @practice.id
      assert_response :success
    end
  end
end
