require File.dirname(__FILE__) + '/../spec_helper'
  
describe VitalSign, "it can validate vital sign entries in a C32" do
  fixtures :abstract_results, :code_systems
  
  before(:each) do
    @vs = abstract_results(:jennifer_thompson_vital_sign)
  end  
  
  it "should validate without errors" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/vital_signs/jenny_vital_sign.xml'))
    errors = @vs.validate_c32(document.root)
    errors.should be_empty
  end
end

describe VitalSign, "it can generate a valid C32 representation of itself" do
  fixtures :abstract_results, :code_systems
  
  before(:each) do

    @vs = abstract_results(:jennifer_thompson_vital_sign)
  end
  
  it "should create valid C32 content" do
    document = LaikaSpecHelper.build_c32 do |xml|
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.16", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "8716-3", 
                   "displayName" => "Vital signs", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title("Vital signs")
          @vs.to_c32(xml)
        end
      end
    end
    
    errors = @vs.validate_c32(document.root)
    errors.should be_empty
  end
end
