require File.dirname(__FILE__) + '/../spec_helper'
describe GenerateAndFormatPlan do
  describe "with schematron validation stubbed out" do
    before do
      @validator = stub(:validator)
      @validator.stub!(:contains_kind_of?).and_return(false)
      Validation.stub!(:get_validator).and_return(@validator)
    end

    describe "to return an empty list" do
      before do
        @validator.should_receive(:validate).and_return([])
      end

      it "should pass validation" do
        plan = GenerateAndFormatPlan.factory.create \
          :clinical_document => ClinicalDocument.factory.create
        plan.validate_clinical_document_content
        plan.should be_passed
      end
    end

    describe "to return a non-empty list" do
      before do
        @validator.should_receive(:validate).and_return([ContentError.factory.create])
      end

      it "should fail validation" do
        plan = GenerateAndFormatPlan.factory.create \
          :clinical_document => ClinicalDocument.factory.create
        plan.validate_clinical_document_content
        plan.should be_failed
      end
    end
  end
end

