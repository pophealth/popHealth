require 'test_helper'
include Devise::TestHelpers

module Api
  module Admin
    class ProvidersControllerTest < ActionController::TestCase

      setup  do
        dump_database
        collection_fixtures 'users'
        @admin = User.where({email: 'admin@test.com'}).first
        @user = User.where({email: 'noadmin@test.com'}).first
      end

      test "count number of providers" do
        sign_in @admin
        get :count
        assert_response :success
        json = JSON.parse(response.body)
        assert_equal json['provider_count'].is_a?(Integer), true
      end

      test "upload provider opml to admin api" do
        sign_in @admin
        providers = fixture_file_upload('test/fixtures/providers.opml', 'text/xml')
        post :create, file: providers
        assert_response :success
      end

      test "should delete providers if admin" do
        sign_in @admin
        delete :destroy
        assert_response :success
      end

      test "should not delete providers if not admin" do
        sign_in @user
        delete :destroy
        assert_response 403
      end

    end
  end
end