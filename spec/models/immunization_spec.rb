require File.dirname(__FILE__) + '/../spec_helper'

describe Immunization, "it can generate a valid C32 representation of itself" do
  fixtures :immunizations, :no_immunization_reasons, :patients
  
  before(:each) do
    @im = immunizations(:emily_jones_immunization)
  end
  
  it "should create valid C32 content" do
    document = LaikaSpecHelper.build_c32 do |xml|
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.6", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "11369-6", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title("Immunizations")
          @im.to_c32(xml)
        end
      end
    end
    
    element = REXML::XPath.first(document, '//cda:lotNumberText', {'cda' => 'urn:hl7-org:v3'})
    element.text.should == 'mm345-417-DFF'
  end
end