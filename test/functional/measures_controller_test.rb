require 'test_helper'
include Devise::TestHelpers

class MeasuresControllerTest < ActionController::TestCase

  setup do
    dump_database
    collection_fixtures 'measures', 'selected_measures', 'records'
    @user = Factory(:user_w_selected_measures)

    @selected_measure = @user.selected_measures.first
    @result = {"measure_id" => @selected_measure['id'],
               "sub_id" => @selected_measure['subs'].first,
               "effective_date" => 1293753600,
               "population" => 322,
               "denominator" => 322,
               "numerator" => 263,
               "antinumerator" => 59,
               "exclusions" => 0 }
    sign_in @user
  end

  test "GET 'definition'" do
    get :definition, :id => '0013'
    assert_response :success
    assert_not_nil assigns(:definition)
  end

  test "dashboard" do
    get :index
    assert_response :success
    # assert_not_nil assigns(:core_measures)
    # assert_not_nil assigns(:core_alt_measures)
    # assert_not_nil assigns(:alt_measures)
  end

  test "period" do
    get :period, effective_date: "12/31/2010", format: :js
    assert_equal Time.utc(2010,12,31).to_i, assigns(:effective_date)
    assert_response :success
  end

  test "effective_date" do
    get :period, effective_date: "12/31/2010", persist: "true", format: :js
    get :index
    assert_equal Time.utc(2010,12,31).to_i, assigns(:effective_date)
    assert_response :success
  end

  test "period_start" do
    get :period, effective_date: "12/31/2010", persist: "true", format: :js
    get :index
    assert_equal Time.utc(2009,12,31).to_i, Time.at(assigns(:period_start)).to_i
    assert_response :success
  end

  test "measure report for practice" do

    @controller.define_singleton_method(:extract_result) do |id, sub_id, effective_date, providers|
      { :id => id, :sub_id => sub_id, :population => 5,
        :denominator => 4, :numerator => 2,
        :exclusions => 0
      }
    end

    get :measure_report, :format => :xml, :type => "practice"
    assert_response :success
  end

  test "measure report for provider" do
      10.times { Factory(:provider)}
      @user.stubs(registry_name: 'registry')
      @user.stubs(registry_id: '1234')
      @user.stubs(npi: '456')
      @user.stubs(tin: '789')

      @controller.define_singleton_method(:extract_result) do |id, sub_id, effective_date, providers|
        { :id => id, :sub_id => sub_id, :population => 5,
          :denominator => 4, :numerator => 2,
          :exclusions => 0
        }
      end

      get :measure_report, :format => :xml, :type => "provider"
      assert_response :success
      d = Digest::SHA1.new
      checksum = d.hexdigest(response.body)
      l = Log.where(:checksum => checksum).first
      assert_not_nil l
      assert_equal @user.username, l.username
  end

  test "view measure page" do
    QME::QualityReport.any_instance.stubs(:result).returns(@result)
    get :show, id: @selected_measure['id'], format: :html
    assert_not_nil assigns(:quality_report)
    assert_not_nil assigns(:result)
    assert_response :success
  end

  test "get measure report" do
    QME::QualityReport.any_instance.stubs(:result).returns(@result)
    QME::QualityReport.any_instance.stubs(:calculated?).returns(true)
    get :show, id: @selected_measure['id'], format: :json
    assert_response :success
  end

  test "provider pagination" do
    provider_count = 5
    provider_count.times { Factory(:provider) }
    xhr :get, :providers, id: @selected_measure['id'], format: :js
    assert_not_nil assigns(:providers)
    assert_response :success
  end

 test "get providers json uncalculated" do
   provider_count = 5
   provider_count.times { Factory(:provider) }

   QME::QualityReport.any_instance.expects(:result).never
   QME::QualityReport.any_instance.stubs(:calculated?).returns(false).times(provider_count)
   QME::QualityReport.any_instance.stubs(:calculate).returns("UUID")
   QME::QualityReport.any_instance.stubs(:status).returns({status: 'working'})
   @providers = Provider.all

   xhr :get, :providers, id: @selected_measure['id'], :format => :json, :provider => @providers.map(&:id)
 end

  test "get providers calculated" do
    provider_count = 5
    provider_count.times { Factory(:provider) }

    QME::QualityReport.any_instance.stubs(:result).returns(@result).times(provider_count)
    QME::QualityReport.any_instance.stubs(:calculated?).returns(true).times(provider_count)

    @providers = Provider.all

    xhr :get, :providers, id: @selected_measure['id'], :format => :json, :provider => @providers.map(&:id)
  end

  test "measure patients" do
    get :measure_patients, id: @selected_measure['id']
    assert_response :success
  end

  test "patient list" do
    5.times { Factory(:record) }
    get :patient_list, id: @selected_measure['id'], format: :xml
  end

end

