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
    measure_id = '0012'
    results = {'0012' => {:bar => 'foo'}}
    answer = helper.value_or_default(measure_id, nil, results, :bar, 0)
    answer.should == 'foo'
  end
  
  it "should be able to find a value in the results with a sub id" do
    measure_id = '0012'
    sub_id = 'a'
    results = {'0012a' => {:bar => 'foo'}}
    answer = helper.value_or_default(measure_id, sub_id, results, :bar, 0)
    answer.should == 'foo'
  end
  
  it "should return the default when it can't find the result" do
    measure_id = '0012'
    results = {}
    answer = helper.value_or_default(measure_id, nil, results, :bar, 0)
    answer.should == 0
  end
  
  it "should be able to calculate the percentage for a measure" do
    measure_id = '0012'
    sub_id = 'a'
    results = {'0012a' => {'numerator' => 2, 'denominator' => 3}}
    answer = helper.percentage(measure_id, sub_id, results)
    answer.should == 66
  end
end