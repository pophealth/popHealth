require 'test_helper'

class LogsHelperTest < ActionView::TestCase
  test "should be able to add the time to the rest of the params" do
    existing_params = {:page => 4}
    params[:log_start_date] = 'tomorrow'
    time_range_params_plus(existing_params)
    assert_equal 4, existing_params[:page]
    assert_equal 'tomorrow', existing_params[:log_start_date]
  end
  
end

