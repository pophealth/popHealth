require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the LogsHelper. For example:
#
# describe LogsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe LogsHelper do
  it "should be able to add the time to the rest of the params" do
    existing_params = {:page => 4}
    helper.params[:log_start_date] = 'tomorrow'
    helper.time_range_params_plus(existing_params)
    existing_params[:page].should == 4
    existing_params[:log_start_date].should == 'tomorrow'
  end
end
