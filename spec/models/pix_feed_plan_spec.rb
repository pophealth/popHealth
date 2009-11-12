require File.dirname(__FILE__) + '/../spec_helper'

describe PixFeedPlan do
  it "should set and get expected PatientIdentifier" do
    plan = PixFeedPlan.factory.create
    pi   = PatientIdentifier.new :patient_identifier => 'foo',
                                 :affinity_domain => 'bar'

    plan.expected = pi
    plan.expected.class.name.should == 'PatientIdentifier'
    plan.matches_expected?(pi).should be_true
  end
end

