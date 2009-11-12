require File.dirname(__FILE__) + '/../spec_helper'

class HasSelectOptionsTester
  extend HasSelectOptionsExtension
  attr_accessor :id, :name
  def initialize(id, name)
    @id, @name = id, name
  end
  def self.find(*args)
    [1..3].map {|i| HasSelectOptionsTester.new(i, "option #{i}") }
  end

  def uc_name
    name.upcase
  end
end

describe HasSelectOptionsExtension do
  describe "by default" do
    before { HasSelectOptionsTester.has_select_options }

    it "should produce an array of name and id pairs" do
      HasSelectOptionsTester.select_options.should == [1..3].map {|i| ["option #{i}", i] }
    end
  
    it "should produce an array of name and id pairs given objects" do
      objects = [1..4].map {|i| HasSelectOptionsTester.new(i, "stuff #{i}") }
      HasSelectOptionsTester.select_options(objects).should == [1..4].map {|i| ["stuff #{i}", i] }
    end
  end

  describe "with a method name" do
    before { HasSelectOptionsTester.has_select_options(:method_name => 'my_options') }

    it "should use that name instead of the default" do
      HasSelectOptionsTester.my_options.should == [1..3].map {|i| ["option #{i}", i] }
    end
  end
  
  describe "with a label column" do
    before { HasSelectOptionsTester.has_select_options(:label_column => 'uc_name') }

    it "should use that column for the option label instead of :name" do
      objects = [1..3].map {|i| HasSelectOptionsTester.new(i, "stuff") }
      HasSelectOptionsTester.select_options(objects).should == [1..3].map {|i| ["STUFF", i] }
    end
  end
  
  describe "with conditions" do
    before { HasSelectOptionsTester.has_select_options(:conditions => 'x = 1') }

    it "should find all with the given conditions, plus default order" do
      HasSelectOptionsTester.should_receive(:find).with(:all, :conditions => 'x = 1', :order => 'name ASC').and_return([])
      HasSelectOptionsTester.select_options
    end
  end

  describe "with order" do
    before { HasSelectOptionsTester.has_select_options(:order => 'id DESC') }

    it "should find all with the given order" do
      HasSelectOptionsTester.should_receive(:find).with(:all, :order => 'id DESC').and_return([])
      HasSelectOptionsTester.select_options
    end
  end

  describe "with a block" do
    before { HasSelectOptionsTester.has_select_options {|r| "i like #{r.name}" } }

    it "should use the block to define returned options" do
      objects = [1..3].map {|i| HasSelectOptionsTester.new(i, "stuff") }
      HasSelectOptionsTester.select_options(objects).should == [1..3].map { "i like stuff" }
    end
  end
end

