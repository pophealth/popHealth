require 'test_helper'
include Devise::TestHelpers
module Api
  class ReportsControllerTest < ActionController::TestCase

    setup do
      dump_database
      collection_fixtures 'measures'
      collection_fixtures 'query_cache'
      collection_fixtures 'records'
      collection_fixtures 'patient_cache'
      collection_fixtures 'providers'
      collection_fixtures 'users'

      @user = User.where({email: "noadmin@test.com"}).first
    end

    test "generate cat3" do
      sign_in @user
      get :cat3, :id=>"523c57e1b59a907ea900000e"
      assert_response :success
    end

    test "generate cat1" do
      sign_in @user
      get :cat1, :id=>"523c57e1b59a907ea900000e", :measure_ids=>"40280381-3D61-56A7-013E-6649110743CE"
      assert_response :success
    end

  end
end
