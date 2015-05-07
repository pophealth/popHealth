require 'test_helper'

  module Api
  class PatientsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup do
      dump_database
      collection_fixtures 'measures', 'patient_cache', 'records', 'users', 'practices', 'providers'
      @user = User.where({email: 'admin@test.com'}).first
      
      @practice1 = Practice.first
      @practice2 = Practice.last
      
      @staff1 = User.where({email: 'noadmin@test.com'}).first   
      @staff2 = User.where({email: 'noadmin2@test.com'}).first
      
      @staff1.practice = @practice1
      @staff2.practice = @practice2
      @staff1.save!
      @staff2.save!
      
      #setup practice 1
      @provider1 = Provider.where({given_name: "William"}).first
      @pp1 = Provider.where('cda_identifiers.extension' => "Test Org").first
      @practice1.provider = @pp1
      @practice1.save!
      
      @provider1.parent = @pp1
      @provider1.save!
      
      #setup practice 2
      @provider2 = Provider.where({given_name: "Anthony"}).first
      @pp2 = Provider.where('cda_identifiers.extension' => "Test Org 2").first 
      @practice2.provider = @pp2
      @practice2.save!
      
      @provider2.parent = @pp2
      @provider2.save!
      
      @record1 = Record.first
      @record1.practice = @practice1
      @record1.provider_performances = [ProviderPerformance.new(provider: @provider1)]
      @record1.save!
      
      @record2 = Record.last
      @record2.practice = @practice2
      @record2.provider_performances = [ProviderPerformance.new(provider: @provider2)]
      @record2.save!     
    end

    test "view patient" do
      sign_in @user
      get :show, id: '523c57e1b59a907ea9000064'
      assert_response :success
    end

    test "can view patient in practice" do
      sign_in @staff1
      get :show, id: @record1.id
      assert_response :success
    end
    
    test "cannot view patient outside of practice" do
      sign_in @staff2
      get :show, id: @record1.id
      assert_response 403    
    end

    test "view patient with include_results includes the results" do
      sign_in @user
      @record = Record.find('523c57e1b59a907ea9000064')

      get :show, id: @record.id, include_results: 'true', format: :json
      assert_response :success
      json = JSON.parse(response.body)
      assert json.has_key?('measure_results')
      assert_equal 2, json['measure_results'].length
    end

    test "uploading a patient record" do
      sign_in @user
      cat1 = fixture_file_upload('test/fixtures/sample_cat1.xml', 'text/xml')
      post :create, file: cat1
      assert_response :success
    end

    test "results" do
      sign_in @user
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
