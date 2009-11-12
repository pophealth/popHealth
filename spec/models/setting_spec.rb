require File.dirname(__FILE__) + '/../spec_helper'

describe Setting do
  it "should get the value by name using hash access" do
    Setting.create!(:name => 'foo', :value => 'bar')
    Setting[:foo].should == 'bar'
  end

  it "should get the value by name using a method call" do
    Setting.create!(:name => 'foo', :value => 'bar')
    Setting.foo.should == 'bar'
  end

  it "should not raise on unknown during hash access" do
    lambda { Setting[:baz] }.should_not raise_error
  end

  it "should raise on unknown during method call" do
    lambda { Setting.baz }.should raise_error(NoMethodError)
  end
end
