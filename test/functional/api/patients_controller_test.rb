require 'test_helper'

  module Api
  class PatientsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup do
      dump_database
      collection_fixtures 'measures', 'patient_cache', 'records', 'users','roles'
      @user = User.where({email: 'admin@test.com'}).first
      sign_in @user
    end

    test "view patient" do
      get :show, id: '523c57e1b59a907ea9000064'
      assert_response :success
    end

    test "count number of patients" do
      get :count
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 8, json['patient_count']
    end

    test "view patient with include_results includes the results" do
      @record = Record.find('523c57e1b59a907ea9000064')

      get :show, id: @record.id, include_results: 'true', format: :json
      assert_response :success
      json = JSON.parse(response.body)
      assert json.has_key?('measure_results')
      assert_equal 2, json['measure_results'].length
    end

    test "uploading a patient record" do
      cat1 = fixture_file_upload('test/fixtures/sample_cat1.xml', 'text/xml')
      post :create, file: cat1
      assert_response :success
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
