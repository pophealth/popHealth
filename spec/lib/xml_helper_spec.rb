require File.dirname(__FILE__) + '/../spec_helper'


describe XmlHelper, "can match values in XML" do
  it "should return nil when a value properly matches" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
    patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
    error = XmlHelper.match_value(patient_element, 'cda:patient/cda:name/cda:given', 'Joe')
    error.should be_nil
  end
  
  it "should return an error string when the values don't match" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
    patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
    error = XmlHelper.match_value(patient_element, 'cda:patient/cda:name/cda:given', 'Billy')
    error.should_not be_nil
    error.should == "Expected Billy got Joe"
  end
  
  it "should return an error string when it can't find the XML it is looking for and the expected value is not nil" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
    patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
    error = XmlHelper.match_value(patient_element, 'cda:patient/cda:foo', 'Billy')
    error.should_not be_nil
    error.should == "Expected Billy got nil"
  end
  
  it "should return nil when the expected value is nil and the expression does not match anything" do
         document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
         patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
         error = XmlHelper.match_value(patient_element, 'some_element_bound_not_to_be_there', nil)
         error.should be_nil
  end
  
  it "should return an error when the expected_value is nil and it matches something" do
         document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
         patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
         error = XmlHelper.match_value(patient_element, '/', nil)
         error.should_not be_nil
  end 
  
  
  it "should return be able to match boolean return values correctly" do
      document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
      patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
      error = XmlHelper.match_value(patient_element, 'cda:patient/cda:name/cda:given/text() = $name',true,{'cda' => 'urn:hl7-org:v3'},{ "name"=>'Joe'})
      error.should be_nil
      
      error = XmlHelper.match_value(patient_element, 'cda:patient/cda:name/cda:given/text() = $name',false,{'cda' => 'urn:hl7-org:v3'},{ "name"=>'Joe'})
      error.should_not be_nil      
  end   
   
  
  
  it "should return be able to match String return values correctly" do
      document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
      patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
      error = XmlHelper.match_value(patient_element, 'cda:patient/cda:name/cda:given/text() ','Joe')
      error.should be_nil
      
      error = XmlHelper.match_value(patient_element, 'cda:patient/cda:name/cda:given/text() ','Bilabo')
      error.should_not be_nil      
  end   
  
  
  it "should return be able to use passed in namespace info" do
      document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
      patient_element = REXML::XPath.first(document, '/c32:ClinicalDocument/c32:recordTarget/c32:patientRole', {'c32' => 'urn:hl7-org:v3'})
      error = XmlHelper.match_value(patient_element, 'c32:patient/c32:name/c32:given/text() ','Joe',{'c32' => 'urn:hl7-org:v3'})
      error.should be_nil   
  end     
    
end