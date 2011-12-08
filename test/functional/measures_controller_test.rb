require 'test_helper'
include Devise::TestHelpers

class MeasuresControllerTest < ActionController::TestCase
  
  setup do
    dump_database
    collection_fixtures 'measures', 'selected_measures', 'records'
    @user = Factory(:user_w_selected_measures)
    sign_in @user
  end
  
  # test "GET 'definition'" do
  #   get :definition, :id => '0013'
  #   assert_response :success
  #   assert_not_nil assigns(:definition)
  # end
  
  # test "GET 'index'" do
  #   
  #   QME::QualityReport.any_instance.expects(:calculated?).returns(true)
  #   
  #   selected_measure = @user.selected_measures.first
  #   query_cache = {"measure_id" => selected_measure['id'],
  #                  "sub_id" => selected_measure['subs'].first,
  #                  "effective_date" => 1293753600,
  #                  "population" => 322,
  #                  "denominator" => 322,
  #                  "numerator" => 263,
  #                  "antinumerator" => 59,
  #                  "exclusions" => 0 }
  # 
  #   QME::QualityReport.any_instance.expects(:result).returns(query_cache)
  #   
  #   get :index
  #   assert_response :success
  #   assert_equal 2, assigns(:patient_count)
  # end
  
  test "GET 'measure_report'" do
      @user.stubs(registry_name: 'registry')
      @user.stubs(registry_id: '1234')
      @user.stubs(npi: '456')
      @user.stubs(tin: '789')
      
      @controller.define_singleton_method(:extract_result) do |id, sub_id, effective_date|
        { :id => id, :sub_id => sub_id, :population => 5,
          :denominator => 4, :numerator => 2,
          :exclusions => 0
        }
      end
      
      get :measure_report, :format => :xml
      assert_response :success
      d = Digest::SHA1.new
      checksum = d.hexdigest(response.body)
      l = Log.first(:conditions => {:checksum => checksum})
      assert_not_nil l
      assert_equal @user.username, l.username
  end
  
  # 
  # test "get measure by providers with precalculated measures" do
  # 
  #   QME::QualityReport.any_instance.stubs(:calculated?).returns(true)
  # 
  #   get :measure, measure_id: '0013'
  # 
  #   selected_providers = assigns[:selected_providers]
  #   definition = assigns[:definition]
  # 
  #   assert_not_nil selected_providers
  #   assert_not_nil definition
  #   assert_not_nil assigns[:teams]
  # 
  #   assert_equal Provider.alphabetical, selected_providers
  #   assert_equal '0013', definition['id']
  #   assert_equal Team.alphabetical, assigns[:teams]
  # 
  #   aggregate_quality_report_uuid = assigns[:aggregate_quality_report_uuid]
  #   provider_job_uuids = assigns[:provider_job_uuids]
  # 
  #   assert_equal nil, aggregate_quality_report_uuid
  #   assert provider_job_uuids.empty?
  # 
  #   aggregate_quality_report = assigns[:aggregate_quality_report]
  #   provider_reports = assigns[:provider_reports]
  # 
  #   assert_not_nil aggregate_quality_report
  #   assert_not_nil provider_reports
  # 
  #   assert_response :success
  # 
  # end
  # 
  # test "get measure by providers with uncalculated measures" do
  # 
  #   QME::QualityReport.any_instance.stubs(:calculated?).returns(false)
  #   QME::QualityReport.any_instance.stubs(:calculate).returns(1)
  # 
  #   get :measure, measure_id: '0013'
  # 
  #   selected_providers = assigns[:selected_providers]
  #   aggregate_quality_report_uuid = assigns[:aggregate_quality_report_uuid]
  #   provider_job_uuids = assigns[:provider_job_uuids]
  # 
  #   assert_equal 1, aggregate_quality_report_uuid
  # 
  #   selected_providers.each do |provider| 
  #     assert_equal 1, provider_job_uuids[provider.id]
  #   end
  # 
  #   aggregate_quality_report = assigns[:aggregate_quality_report]
  #   provider_reports = assigns[:provider_reports]
  # 
  #   assert_not_nil aggregate_quality_report
  #   assert_not_nil provider_reports
  # 
  #   assert_response :success    
  # end
  # 
  # test "get measures by provider with selected providers passed in" do
  #   QME::QualityReport.any_instance.stubs(:calculated?).returns(false)
  #   QME::QualityReport.any_instance.stubs(:calculate).returns(1)
  # 
  #   get :measure, measure_id: '0013', selected_provider_ids: [@provider.id]
  # 
  #   selected_providers = assigns[:selected_providers]
  #   aggregate_quality_report_uuid = assigns[:aggregate_quality_report_uuid]
  #   provider_job_uuids = assigns[:provider_job_uuids]
  # 
  #   assert_equal 1, aggregate_quality_report_uuid
  #   assert_equal 1, selected_providers.size
  #   assert_equal @provider, selected_providers.first
  # 
  #   selected_providers.each do |provider| 
  #     assert_equal 1, provider_job_uuids[provider.id]
  #   end
  # 
  #   aggregate_quality_report = assigns[:aggregate_quality_report]
  #   provider_reports = assigns[:provider_reports]
  # 
  #   assert_not_nil aggregate_quality_report
  #   assert_not_nil provider_reports
  # 
  #   assert_response :success    
  # 
  # end
  # 
  # 
  # test "get measures by provider json" do
  #   QME::QualityReport.any_instance.stubs(:calculated?).returns(false)
  #   QME::QualityReport.any_instance.stubs(:calculate).returns(1)
  # 
  #   get :measure, measure_id: '0013', format: 'json'
  # 
  #   json = JSON.parse(response.body)
  # 
  #   assert_equal nil, json['aggregate']
  #   assert_equal Provider.all.size, json['providers'].size
  #   assert_equal nil, json['providers'][@provider.id.to_s]
  #   assert_equal nil, json['providers'][@other_provider.id.to_s]
  #   assert_equal 1, json['aggregate_job']
  #   assert_equal 1, json['provider_jobs'][@provider.id.to_s]
  #   assert_equal 1, json['provider_jobs'][@other_provider.id.to_s]
  # 
  # end
  # 
  # test "get measures by provider json with selected provider" do
  #   QME::QualityReport.any_instance.stubs(:calculated?).returns(false)
  #   QME::QualityReport.any_instance.stubs(:calculate).returns(1)
  # 
  #   get :measure, measure_id: '0013', selected_provider_ids: [@provider.id], format: 'json'
  # 
  #   json = JSON.parse(response.body)
  # 
  #   assert_equal nil, json['aggregate']
  #   assert_equal 1, json['providers'].size
  #   assert_equal nil, json['providers'][@provider.id.to_s]
  #   assert_equal 1, json['aggregate_job']
  #   assert_equal 1, json['provider_jobs'][@provider.id.to_s]
  # 
  # end
  # 
  # test "get measures by provider json with calculated result" do
  # 
  #   aggregate_result = Factory(:query_cache, measure_id: '0013', filters: { 'providers' => Provider.all.map {|provider| provider.id.to_s} })
  # 
  #   provider_results = {}
  #   Provider.all.map(&:id).each do |provider_id| 
  #     provider_results[provider_id.to_s] = Factory(:query_cache, measure_id: '0013', filters: { 'providers' => [ provider_id.to_s ] })
  #   end
  # 
  #   get :measure, measure_id: '0013', format: 'json'
  # 
  #   json = JSON.parse(response.body)
  # 
  #   assert_equal nil, json['aggregate_job']
  #   assert json['provider_jobs'].empty?
  #   assert json['complete']
  #   assert_equal Provider.all.size, json['providers'].size
  # 
  #   assert_query_results_equal json['aggregate'], aggregate_result
  #   provider_results.each do |key, value|
  #     assert_query_results_equal json['providers'][key], value
  #   end
  # 
  # 
  # end
  # 
  # 
  # test "get measures by provider json with calculated results and selected provider" do
  #   aggregate_result = Factory(:query_cache, measure_id: '0013', filters: { 'providers' => [@provider.id.to_s] })
  # 
  #   get :measure, measure_id: '0013', selected_provider_ids: [@provider.id], format: 'json'
  # 
  #   json = JSON.parse(response.body)
  # 
  #   assert_equal nil, json['aggregate_job']
  #   assert json['provider_jobs'].empty?
  #   assert json['complete']
  #   assert_equal 1, json['providers'].size
  # 
  #   assert_query_results_equal json['aggregate'], aggregate_result
  #   assert_query_results_equal json['providers'][@provider.id.to_s], aggregate_result
  # 
  # end
  # 
  # 
  # test "get measures by provider json with partial calculation" do
  # 
  #   QME::QualityReport.any_instance.stubs(:calculate).returns(1)
  # 
  #   aggregate_result = Factory(:query_cache, measure_id: '0013', filters: { 'providers' => Provider.all.map {|provider| provider.id.to_s} })
  #   provider_result = Factory(:query_cache, measure_id: '0013', filters: { 'providers' => [@provider.id.to_s] })
  # 
  #   get :measure, measure_id: '0013', format: 'json'
  # 
  #   json = JSON.parse(response.body)
  # 
  #   assert_equal nil, json['aggregate_job']
  #   assert_equal 1, json['provider_jobs'][@other_provider.id.to_s]
  #   assert_nil json['provider_jobs'][@provider.id.to_s]
  #   assert_equal 1, json['provider_jobs'].size
  #   assert_false json['complete']
  #   assert_equal Provider.all.size, json['providers'].size
  #   assert_nil json['providers'][@other_provider.id.to_s]
  #   assert_not_nil json['providers'][@provider.id.to_s]
  #    
  #   assert_query_results_equal json['aggregate'], aggregate_result
  #   assert_query_results_equal json['providers'][@provider.id.to_s], provider_result
  # end
  # 
  # test "get measures by provider json with aggregation not calculated" do
  # 
  #   QME::QualityReport.any_instance.stubs(:calculate).returns(1)
  # 
  #   provider_result = Factory(:query_cache, measure_id: '0013', filters: { 'providers' => [@provider.id.to_s] })
  # 
  #   get :measure, measure_id: '0013', format: 'json'
  # 
  #   json = JSON.parse(response.body)
  # 
  #   assert_equal 1, json['aggregate_job']
  #   assert_equal 1, json['provider_jobs'][@other_provider.id.to_s]
  #   assert_nil json['provider_jobs'][@provider.id.to_s]
  #   assert_equal 1, json['provider_jobs'].size
  #   assert_false json['complete']
  #   assert_equal Provider.all.size, json['providers'].size
  #   assert_nil json['providers'][@other_provider.id.to_s]
  #   assert_not_nil json['providers'][@provider.id.to_s]
  #   
  #   assert_nil json['aggregate']
  #    
  #   assert_query_results_equal json['providers'][@provider.id.to_s], provider_result
  # end
  
end
  