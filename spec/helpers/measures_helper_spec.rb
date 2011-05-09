require 'spec_helper'

describe MeasuresHelper do
  it "should be able to iterate through a list of sub ids" do
    subs = ['a']
    helper.subs_iterator(subs) do |sub_id|
      sub_id.should == 'a'
    end
  end
  
  it "should iterate once when there are no sub ids" do
    subs = [nil]
    helper.subs_iterator(subs) do |sub_id|
      sub_id.should == nil
    end
  end
  
  it "should be able to find a value in the results" do
    results = {:bar => 'foo'}
    answer = helper.value_or_default(results, :bar, 0)
    answer.should == 'foo'
  end
  
  it "should return the default when it can't find the result" do
    results = {}
    answer = helper.value_or_default(results, :bar, 0)
    answer.should == 0
  end
  
  it "should be able to calculate the percentage for a measure" do
    results = {'numerator' => 2, 'denominator' => 3}
    answer = helper.percentage(results)
    answer.should == 66
  end
end