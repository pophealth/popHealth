require File.dirname(__FILE__) + '/../spec_helper'

describe ApplicationHelper do
  describe 'current_controller?' do
    it "should return true for current" do
      helper.stub!(:controller => mock('controller', :controller_name => 'mything'))
      helper.current_controller?('mything').should be_true
    end

    it "should return false if not current" do
      helper.current_controller?('foobar').should be_false
    end

    it "should work with a symbol" do
      helper.stub!(:controller => mock('controller', :controller_name => 'yourthing'))
      helper.current_controller?(:yourthing).should be_true
    end
  end

  describe 'requirements_for' do
    it "should specify required" do
      model = mock('model', :requirements => { :foo => :required })
      doc = REXML::Document.new(helper.requirements_for(model, :foo))
      doc.root.text.should == 'Required'
      doc.root.attributes['class'].should match(/\bvalidation_for\b/)
      doc.root.attributes['class'].should match(/\brequired\b/)
    end

    it "should specify hitsp_required" do
      model = mock('model', :requirements => { :foo => :hitsp_required })
      doc = REXML::Document.new(helper.requirements_for(model, :foo))
      doc.root.text.should == 'Required (HITSP R)'
      doc.root.attributes['class'].should match(/\bvalidation_for\b/)
      doc.root.attributes['class'].should match(/\brequired\b/)
    end

    it "should specify hitsp_r2_required" do
      model = mock('model', :requirements => { :foo => :hitsp_r2_required })
      doc = REXML::Document.new(helper.requirements_for(model, :foo))
      doc.root.text.should == 'Required (HITSP R2)'
      doc.root.attributes['class'].should match(/\bvalidation_for\b/)
      doc.root.attributes['class'].should match(/\brequired\b/)
    end

    it "should specify hitsp_optional" do
      model = mock('model', :requirements => { :foo => :hitsp_optional })
      doc = REXML::Document.new(helper.requirements_for(model, :foo))
      doc.root.text.should == 'Optional (HITSP R)'
      doc.root.attributes['class'].should match(/\bvalidation_for\b/)
      doc.root.attributes['class'].should_not match(/\brequired\b/)
    end

    it "should specify hitsp_r2_optional" do
      model = mock('model', :requirements => { :foo => :hitsp_r2_optional })
      doc = REXML::Document.new(helper.requirements_for(model, :foo))
      doc.root.text.should == 'Optional (HITSP R2)'
      doc.root.attributes['class'].should match(/\bvalidation_for\b/)
      doc.root.attributes['class'].should_not match(/\brequired\b/)
    end
  end
end
