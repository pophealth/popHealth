require 'test_helper'
include Devise::TestHelpers
  module Api
  class MeasuresControllerTest < ActionController::TestCase

    setup do
      dump_database
      collection_fixtures 'measures', 'records'
      @user = Factory(:user)
      @admin = Factory(:admin)
      
    end

    test "GET 'definition'" do
      sign_in @user
      get :show, :id => '0013'
      assert_response :success
      body = response.body
      json = JSON.parse(body)
      assert_equal "0013", json["hqmf_id"]
    end

    test "index" do
      sign_in @user
      get :index
      assert_response :success
    end

    test "simple user cannot delete measures" do
      sign_in @user
      count = QME::QualityMeasure.where({"hqmf_id" => "0013"}).count
      assert 0< count
      delete :destroy, :id=>'0013'

      assert_response 403
      assert_equal count, QME::QualityMeasure.where({"hqmf_id" => "0013"}).count, "No measures should have been deleted"
    end

     test "admin can delete measures" do
      sign_in @admin
      count = QME::QualityMeasure.where({"hqmf_id" => "0013"}).count
      assert 0< count, "should be at least one 0013 measure database"
      delete :destroy, :id=>'0013'
      assert_response 204
      assert_equal 0, QME::QualityMeasure.where({"hqmf_id" => "0013"}).count, "There should be 0 measures with the HQMF id 0013 in the db"
    end
    
    test "create" do
      skip "need to implement"
    end

  end
end
