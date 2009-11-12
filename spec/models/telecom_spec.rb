require File.dirname(__FILE__) + '/../spec_helper'

describe Telecom do
  it 'should be blank if all fields are empty' do
    Telecom.new.should be_blank
  end

  %w[
    home_phone work_phone mobile_phone vacation_home_phone email url
  ].each do |attr|
    it "should not be blank if #{attr} field is not empty" do
      Telecom.new(attr => "0").should_not be_blank
    end
  end

  describe "when validating" do
    fixtures :telecoms
    
    before(:each) do
      @telecom = telecoms(:jennifer_thompsons_telecom)
    end
    
    it "should properly verify telecoms with a use attribute" do
      document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/telecom/jenny_telecom_with_uses.xml'))
      errors = @telecom.validate_c32(document.root)
      errors.should be_empty
    end
    
    it "should properly verify telecoms with out a use attribute" do
      document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/telecom/jenny_telecom_no_uses.xml'))
      errors = @telecom.validate_c32(document.root)
      errors.should be_empty
    end
    
    it "should find errors when the use attribute is wrong" do
      document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/telecom/jenny_telecom_wrong_uses.xml'))
      errors = @telecom.validate_c32(document.root)
      errors.should_not be_empty
      errors.should have(2).errors
      errors[1].error_message.should.eql? "Expected use HP got HV"
    end
    
    it "should find errors when a telecom is missing" do
      document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/telecom/jenny_telecom_missing_mobile.xml'))
      errors = @telecom.validate_c32(document.root)
      errors.should_not be_empty
      errors.should have(1).error
      errors[0].error_message.should.eql? "Couldn't find the telecom for MC"
    end
  end
end
