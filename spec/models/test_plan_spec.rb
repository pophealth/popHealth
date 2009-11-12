require File.dirname(__FILE__) + '/../spec_helper'

# Test plan type used for testing.
class MyTestPlan < TestPlan
  test_name 'My Test Plan'
end

describe TestPlan do
  before { Laika::TEST_PLAN_TYPES['My Test Plan'] = MyTestPlan }
  after { Laika::TEST_PLAN_TYPES.delete 'My Test Plan' }

  it "should list all test plans" do
    TestPlan.test_types.values.should include(MyTestPlan)
  end

  it "should start in pending state" do
    MyTestPlan.factory.create.state.should == 'pending'
  end

  it "should transition from pending to passed" do
    MyTestPlan.factory.create.tap(&:pass).state.should == 'passed'
  end

  it "should transition from pending to failed" do
    MyTestPlan.factory.create.tap(&:fail).state.should == 'failed'
  end
end

