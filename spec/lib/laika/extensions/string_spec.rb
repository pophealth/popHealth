require File.dirname(__FILE__) + '/../../../spec_helper'

describe Laika::Extensions::String do
  it "should convert a String containing an HL7 timestamp into a Date" do
    the_date = '20060221'.from_hl7_ts_to_date
    the_date.year.should == 2006
    the_date.month.should == 2
    the_date.day.should == 21
  end
end