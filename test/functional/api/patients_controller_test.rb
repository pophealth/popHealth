require 'test_helper'

  module Api
  class PatientsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    setup do
      dump_database
      collection_fixtures 'measures', 'patient_cache', 'records', 'users', 'providers'
      @admin_user = User.where({email: 'admin@test.com'}).first
			@staff_user = User.where({username: "staffa"}).first

			@practicea = Provider.where({given_name: "Practice A"}).first
			@providera = Provider.where({"organization.name" => "Practice A"}).first

			@providera.parent_id = @practicea.id
			@providera.parent_ids= [@practicea.id]
			@providera.save!
			
			@practice_patient = Record.where(:first=> "Jennifer", :last=>"Snyder").first
			@other_patient= Record.first

			@staff_user.provider = @practicea.id
			@staff_user.save!
			
			perf = ProviderPerformance.new( :provider_id => @providera.id )
			@practice_patient.provider_performances = [ perf ]
			@practice_patient.save!
      
#      sign_in @user
    end

    test "view patient as admin" do
      sign_in @admin_user
      get :show, id: '523c57e1b59a907ea9000064'
      assert_response :success
    end

		test "view patient as staff" do
			sign_in @staff_user
      
      # allow staff to see patient within practice
      get :show, id: @practice_patient.id
      assert_response :success
			
      # do not allow staff to see patient outside practice
			get :show, id: @other_patient.id
      assert_response 403
		end

    test "count number of patients" do
      sign_in @admin_user
      get :count
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 9, json['patient_count']
    end

    test "view patient with include_results includes the results" do
      sign_in @admin_user
      @record = Record.find('523c57e1b59a907ea9000064')

      get :show, id: @record.id, include_results: 'true', format: :json
      assert_response :success
      json = JSON.parse(response.body)
      assert json.has_key?('measure_results')
      assert_equal 2, json['measure_results'].length
    end

    test "uploading a patient record" do
      sign_in @admin_user
      cat1 = fixture_file_upload('test/fixtures/sample_cat1.xml', 'text/xml')
      post :create, file: cat1
      assert_response :success
    end

    test "results" do
      sign_in @admin_user
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
