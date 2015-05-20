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
      collection_fixtures 'practices'
      
      @user = User.where({email: "noadmin@test.com"}).first
      @user.preferences["selected_measure_ids"] = ["40280381-4600-425F-0146-1F6F722B0F17"]    
      @user.save!
      
      @practice = Practice.all.first
      identifier = CDAIdentifier.new(:root => "Organization", :extension => @practice.organization)
      practice_provider = Provider.where('cda_identifiers.root' => "Organization").first
      practice_provider.cda_identifiers << identifier
      practice_provider.practice = @practice
      practice_provider.save
      @practice.provider = practice_provider
      @practice.save!

      @user.practice = @practice
      @user.save!

      @provider = Provider.where({family_name: "Darling"}).first
      @provider.parent = practice_provider
      @provider.save!

      query = QME::QualityReport.where(effective_date: 1356998341).first
      query.filters["providers"] = [@provider.id.to_s]
      query.save!
    end

    test "generate cat3" do
      sign_in @user
      get :cat3, :provider_id=> Provider.first.id
      assert_response :success

      cdastring = @response.body
      assert cdastring.include? "ClinicalDocument"
      cdastring.include? "2.16.840.1.113883.4.2"
    end

    test "generate cat1" do
      sign_in @user
      
      APP_CONFIG['use_opml_structure'] = true
      
      get :cat1, :id=>"523c57e1b59a907ea900000e", :measure_ids=>"40280381-3D61-56A7-013E-6649110743CE"
      assert_response :success
    
      cdastring = @response.body
      assert cdastring.include? "ClinicalDocument"
      assert cdastring.include? "Ella"
      assert cdastring.include? "40280381-3D61-56A7-013E-6649110743CE"
      
      APP_CONFIG['use_opml_structure'] = false
    end

    test "don't allow generate cat1 for non practice user" do
      sign_in @user
      APP_CONFIG['use_opml_structure'] = false    
      get :cat1, :id=>"523c57e1b59a907ea900000e", :measure_ids=>"40280381-3D61-56A7-013E-6649110743CE"
      assert_response 403
      APP_CONFIG['use_opml_structure'] = true
    end

    test "generate patient outliers spreadsheet" do
      sign_in @user
      get :patients, :id=>"40280381-3D61-56A7-013E-6649110743CE", :effective_date=>123, :patient_type=>"antinumerator", :provider_id => @provider.id
      assert_response :success
      
      spreadsheet = @response.body
      assert spreadsheet.include? "Outlier"
      assert spreadsheet.include? "Use of Appropriate Medications for Asthma"
    end

    test "generate measure dashboard spreadsheet" do
      sign_in @user
      get :measures_spreadsheet, :username => @user.username, :provider_id => @provider.id, :effective_date => "1356998341"
      assert_response :success
    end

  end
end
