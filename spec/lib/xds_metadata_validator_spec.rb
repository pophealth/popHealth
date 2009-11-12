require File.dirname(__FILE__) + '/../spec_helper'

describe Validators::XdsMetadataValidator, "can validate xds metadata" do
  it "should tell when a coded attribute is blank" do
    Validators::XdsMetadataValidator.coded_attribute_blank?(nil).should be_true
    Validators::XdsMetadataValidator.coded_attribute_blank?(XDS::CodedAttribute.new(:class_code)).should be_true
    Validators::XdsMetadataValidator.coded_attribute_blank?(XDS::CodedAttribute.new(:class_code, 'foo')).should be_false
  end
  
  it "should tell when an author is blank" do
    Validators::XdsMetadataValidator.author_blank?(nil).should be_true
    Validators::XdsMetadataValidator.author_blank?(XDS::Author.new).should be_true
    Validators::XdsMetadataValidator.author_blank?(XDS::Author.new('foo')).should be_false
  end
  
  it "should tell when a source patient identifier is blank" do
    Validators::XdsMetadataValidator.source_patient_info_blank?(nil).should be_true
    Validators::XdsMetadataValidator.source_patient_info_blank?(XDS::SourcePatientInfo.new).should be_true
    Validators::XdsMetadataValidator.source_patient_info_blank?(XDS::SourcePatientInfo.new(:name => 'foo')).should be_false
  end
  
  it "should tell when metadata are equal" do
    expected = XDS::Metadata.new
    actual = XDS::Metadata.new
    expected.class_code = XDS::CodedAttribute.new(:class_code, 'foo')
    actual.class_code = XDS::CodedAttribute.new(:class_code, 'foo')
    expected.patient_id = '123'
    actual.patient_id = '123'
    validator = Validators::XdsMetadataValidator.new
    results = validator.validate(expected, actual)
    results.should be_empty
  end
  
  it "should tell when metadata are not equal" do
    expected = XDS::Metadata.new
    actual = XDS::Metadata.new
    expected.class_code = XDS::CodedAttribute.new(:class_code, 'foo')
    actual.class_code = XDS::CodedAttribute.new(:class_code, 'bar')
    expected.source_patient_info = XDS::SourcePatientInfo.new(:name => 'foo')
    actual.source_patient_info = XDS::SourcePatientInfo.new(:name => 'foo')
    expected.patient_id = '123'
    actual.patient_id = '123'
    validator = Validators::XdsMetadataValidator.new
    results = validator.validate(expected, actual)
    results.should_not be_empty
    results.length.should == 1
  end
  
end
