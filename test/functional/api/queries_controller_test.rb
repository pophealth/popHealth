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
      collection_fixtures 'users'

      @staff = User.where({email: 'noadmin@test.com'}).first
      @admin = User.where({email: 'admin@test.com'}).first
      @user = User.where({email: 'nostaff@test.com'}).first
            
      @practicea = Provider.where({given_name: "Practice A"}).first
      @practiceb = Provider.where({given_name: "Practice B"}).first	

      @staffa = User.where({username: "staffa"}).first
      @staffa.provider = @practicea.id
      @staffa.save!
            
      @staffb = User.where({username: "staffb"}).first
      @staffb.provider = @practiceb.id
      @staffb.save!

      @providera1 = Provider.where({"organization.name" => "Practice A"}).first
      @providera2 = Provider.where({"organization.name" => "Practice A"}).last	
      @providerb1 = Provider.where({"organization.name" => "Practice B"}).first
      @providerb2 = Provider.where({"organization.name" => "Practice B"}).last	

      # setting providers to practices
      Provider.where({"organization.name" => "Practice A"}).each do |prov|
        prov.parent_id = @practicea.id
        prov.parent_ids.push @practicea.id
        prov.save
      end
      
      @practice_patient = Record.where(:first=> "Jennifer", :last=>"Snyder").first
      perf = ProviderPerformance.new( :provider_id => @providera1.id )
      @practice_patient.provider_performances = [ perf ]
      @practice_patient.save!
      
      Provider.where({"organization.name" => "Practice B"}).each do |prov|
      	prov.parent_id = @practiceb.id
        prov.parent_ids.push @practiceb.id
        prov.save
      end
            
      @npi_user = User.where({email: 'npiuser@test.com'}).first
      @npi_user.staff_role=false
      @npi_user.save

      @provider = Provider.where({family_name: "Darling"}).first
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
      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@provider.id]
      assert_response :success, "admin should be able to create reports for npis "

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212
      assert_response :success, "admin should be able to create reports for no npi "
    end

    test "create staff" do
      sign_in @staffa

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@practicea.id]
      assert_response :success, "staff should be able to create reports for its practice's providers"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@providera1.id]
      assert_response :success, "staff should be able to create reports for its practice's provider"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@providera2.id]
      assert_response :success, "staff should be able to create reports for its practice's provider #2"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@practiceb.id]
      assert_response 403, "staff should not be able to create reports for providers outside of their practice"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@providerb1.id]
      assert_response 403, "staff should not be able to create reports for providers outside of their practice #2"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@providerb2.id]
      assert_response 403, "staff should not be able to create reports for providers outside of their practice #3"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212
      assert_response 403, "staff should not be able all reports for no npi"
    end
    
    test "create npi user" do
      sign_in @npi_user
      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@provider.id]
      assert_response :success, "should be able to create a quality report for users own npi"

      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212
      assert_response 403, "should be unauthorized without npi" 

    end

    test "create unauthorized" do
      sign_in @user
      post :create, :measure_id=>'40280381-3D61-56A7-013E-6649110743CE', :sub_id=>"a", :effective_date=>1212121212, :providers=>[@provider.id]
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
