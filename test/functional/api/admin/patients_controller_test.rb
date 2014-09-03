require 'test_helper'
include Devise::TestHelpers

module Api
  module Admin
    class PatientsControllerTest < ActionController::TestCase

      setup do
        dump_database
        collection_fixtures 'users'
        @admin = User.where({email: 'admin@test.com'}).first
        @user = User.where({email: 'noadmin@test.com'}).first
      end

      test "count number of patients" do
        sign_in @admin
        get :count
        assert_response :success
        json = JSON.parse(response.body)
        assert_equal json['patient_count'].is_a?(Integer), true
      end

      test "should delete patients if admin" do
        sign_in @admin
        delete :destroy
        assert_response :success
      end

      test "should not delete patients if not admin" do
        sign_in @user
        delete :destroy
        assert_response 403
      end

      test "upload patients via zip" do
        sign_in @admin
        patients = fixture_file_upload('test/fixtures/patient_sample.zip', 'application/zip')
        post :create, file: patients
        assert_response :success
      end

    end
  end
end