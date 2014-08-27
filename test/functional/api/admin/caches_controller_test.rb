require 'test_helper'
include Devise::TestHelpers

module Api
  module Admin
    class CachesControllerTest < ActionController::TestCase

      setup do
        dump_database
        collection_fixtures 'users'
        @admin = User.where({email: 'admin@test.com'}).first
        @user = User.where({email: 'noadmin@test.com'}).first
      end

      test "should fetch integer cache counts from DB" do
        sign_in @admin
        get :count
        assert_response :success
        json = JSON.parse(response.body)
        assert_equal json['query_cache_count'].is_a?(Integer), true
        assert_equal json['patient_cache_count'].is_a?(Integer), true
      end

      test "should delete caches if admin" do
        sign_in @admin
        delete :destroy
        assert_response :success
      end

      test "should not delete caches if not admin" do
        sign_in @user
        delete :destroy
        assert_response 403
      end

    end
  end
end