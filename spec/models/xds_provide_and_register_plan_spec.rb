require File.dirname(__FILE__) + '/../spec_helper'
describe XdsProvideAndRegisterPlan do
  it "should fail to validate without metadata" do
    plan = XdsProvideAndRegisterPlan.factory.create
    plan.validate_xds_metadata nil
    plan.should be_failed
  end

  describe "with validation stubbed out" do
    before do
      @validator = mock(:validator)
      Validators::XdsMetadataValidator.stub!(:new).and_return(@validator)
      XDSUtils.stub!(:retrieve_document)
    end
  
    it "should pass validation with no content errors" do
      @validator.should_receive(:validate).and_return([])
  
      plan = XdsProvideAndRegisterPlan.factory.create
      plan.validate_xds_metadata XDS::Metadata.new
      plan.should be_passed
    end
  
    it "should fail validation with content errors" do
      @validator.should_receive(:validate).and_return([ContentError.factory.create])
  
      plan = XdsProvideAndRegisterPlan.factory.create
      plan.validate_xds_metadata XDS::Metadata.new
      plan.should be_failed
    end
  end
end

