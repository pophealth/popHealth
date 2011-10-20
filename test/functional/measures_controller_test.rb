require 'test_helper'
include Devise::TestHelpers

class MeasuresControllerTest < ActionController::TestCase
  
  setup do
    dump_database
    collection_fixtures 'measures', 'selected_measures', 'records'
    @user = Factory(:user_w_selected_measures)
    sign_in @user
  end
  
  test "GET 'definition'" do
    get :definition, :id => '0013'
    assert_response :success
    assert_not_nil assigns(:definition)
  end
  
  test "GET 'index'" do
    
    QME::QualityReport.any_instance.expects(:calculated?).returns(true)

    selected_measure = @user.selected_measures.first
    query_cache = {"measure_id" => selected_measure['id'],
                   "sub_id" => selected_measure['subs'].first,
                   "effective_date" => 1293753600,
                   "population" => 322,
                   "denominator" => 322,
                   "numerator" => 263,
                   "antinumerator" => 59,
                   "exclusions" => 0 }

    QME::QualityReport.any_instance.expects(:result).returns(query_cache)
    
    get :index
    assert_response :success
    assert_equal 2, assigns(:patient_count)
    
    assert assigns(:grouped_selected_measures).keys.include?("Women's Health")
  end
  
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
      assert_equal @user.username, l.username
  end
  
end
  