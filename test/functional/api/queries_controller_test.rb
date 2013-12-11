require 'test_helper'
include Devise::TestHelpers
module Api
  class QueriesControllerTest < ActionController::TestCase
    
    setup do
      dump_database
      collection_fixtures 'measures'
      collection_fixtures 'query_cache'
      collection_fixtures 'records'
      collection_fixtures 'patient_cache'
      collection_fixtures 'providers'

      @staff = Factory(:user)
      @admin = Factory(:user)
      @user = Factory(:user)
      @user.staff_role=false
      @user.save

      @npi_user = Factory(:user_w_npi)
      @npi_user.staff_role=false
      @npi_user.save

      @provider = Factory(:provider)
      @provider.npi = @npi_user.npi
      @provider.save

      QME::QualityReport.where({}).each do |q|
        if q.filters
          q.filters["providers"] = [@provider.id]
          q.save
        end
      end

      QME::PatientCache.where({}).each do |pc|
        if pc.value["filters"]
          pc.value["filters"]["providers"] = [@provider.id]
          pc.save
        end
      end
    end



    test "show admin" do 
      sign_in @admin
      get :show, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end
    
    test "show npi" do 
      sign_in @npi_user
      get :show, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end

    test "show unauthorized" do 
      sign_in @user
      get :show, :id=>"523c57e2949d9dd06956b606"
      assert_response 403
    end

    test "show staff_role" do 
      sign_in @staff
      get :show, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end

    test "delete admin" do 
      sign_in @admin
      delete :destroy, :id=>"523c57e2949d9dd06956b606"
      assert_response 204
    end
    
    test "delete npi" do 
      sign_in @npi_user
      delete :destroy, :id=>"523c57e2949d9dd06956b606"
      assert_response 204
    end

    test "delete unauthorized" do 
      sign_in @user
      delete :destroy, :id=>"523c57e2949d9dd06956b606"
      assert_response 403
    end

    test "delete staff_role" do 
      sign_in @staff
      delete :destroy, :id=>"523c57e2949d9dd06956b606"
      assert_response 204
    end


    test "recalculate admin" do 
      sign_in @admin
      get :recalculate, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end
    
    test "recalculate npi" do 
      sign_in @npi_user
      get :recalculate, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end

    test "recalculate unauthorized" do 
      sign_in @user
      get :recalculate, :id=>"523c57e2949d9dd06956b606"
      assert_response 403
    end

    test "recalculate staff_role" do 
      sign_in @staff
      get :recalculate, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end

    test "patient_results admin" do 
      sign_in @admin
      get :patient_results, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end
    
    test "patient_results npi" do 
      sign_in @npi_user
      get :patient_results, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end

    test "patient_results unauthorized" do 
      sign_in @user
      get :patient_results, :id=>"523c57e2949d9dd06956b606"
      assert_response 403
    end

    test "patient_results staff_role" do 
      sign_in @staff
      get :patient_results, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end



    test "patients admin" do 
      sign_in @admin
      get :patients, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end
    
    test "patients npi" do 
      sign_in @npi_user
      get :patients, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end

    test "patients unauthorized" do 
      sign_in @user
      get :patients, :id=>"523c57e2949d9dd06956b606"
      assert_response 403
    end

    test "patients staff_role" do 
      sign_in @staff
      get :patients, :id=>"523c57e2949d9dd06956b606"
      assert_response :success
    end

    
    test "create admin" do
      sign_in @admin
      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :filter=>{:providers=>[@provider.id]}
      assert_response :success, "admin should be able to create reports for npis "

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212
      assert_response :success, "admin should be able to create reports for no npi "
    end

    test "create staff" do
      sign_in @staff
      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212,:filter=>{:providers=>[@provider.id]}
      assert_response :success, "staff should be able to create all reports for npis"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212
      assert_response :success, "staff should be able to create all reports for no npi"
    end 

    test "create npi user" do
      sign_in @npi_user
      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE',  :sub_id=>"a",:effective_date=>1212121212, :filter=>{:providers=>[@provider.id]}
      assert_response :success, "should be able to create a quality report for users own npi"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212
      assert_response 403, "should be unauthorized without npi"
    end

    test "create unauthorized" do
      sign_in @user
      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE',  :sub_id=>"a",:effective_date=>1212121212,:filter=>{:providers=>[@provider.id]}
      assert_response 403, "Should be unauthorized for npi"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212
      assert_response 403, "Should be unauthorized with no npi"

    end 


    test "filter patient results" do
      sign_in @staff
      get :patients, :id=>"523c57e4949d9dd06956b622"
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 1, json.length

      get :patients, :id=>"523c57e4949d9dd06956b622", :denex=>"true"
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 0, json.length

      get :patients, :id=>"523c57e4949d9dd06956b622", :denom=>"true"
      assert_response :success
      json = JSON.parse(response.body)
      assert_equal 1, json.length

    end

    test "index admin" do 
      skip "need to implement"
    end
    
  end
end
