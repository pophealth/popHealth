require 'test_helper'

  module Api
  class PatientsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup do
      dump_database
      collection_fixtures 'measures', 'patient_cache', 'records'
      @record = Factory(:record)
      @user = Factory(:user)
      sign_in @user
    end

    test "view patient" do
      get :show, id: @record.id
    end

    test "view patient with include_results includes the results" do
      @record = Record.find('523c57e1b59a907ea9000064')

      get :show, id: @record.id, include_results: 'true', format: :json
      assert_response :success
      json = JSON.parse(response.body)
      assert json.has_key?('measure_results')
      assert_equal 2, json['measure_results'].length
    end


    test "results" do
      @record = Record.find('523c57e1b59a907ea9000064')

      get :results, id: @record.id
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 2, json.length

      get :results, id: @record.id, measure_id: "40280381-3D61-56A7-013E-6649110743CE", sub_id: "a"
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 1, json.length
    end

  end
end
