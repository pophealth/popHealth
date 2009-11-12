require File.dirname(__FILE__) + '/../spec_helper'
  
describe Result, "it can validate result entries in a C32" do
  fixtures :abstract_results, :code_systems
  
  before(:each) do
    @result = abstract_results(:jennifer_thompson_result)
  end  
  
  it "should validate without errors" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/results/jenny_result.xml'))
    errors = @result.validate_c32(document.root)
    errors.should be_empty
  end
end

describe Result, "it can generate a valid C32 representation of itself" do
  fixtures :abstract_results, :code_systems
  
  before(:each) do
    @result = abstract_results(:jennifer_thompson_result)
  end
  
  it "should create valid C32 content" do
    document = LaikaSpecHelper.build_c32 do |xml|
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.14", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "30954-2", 
                   "displayName" => "Relevant diagnostic tests", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title("Results")
          @result.to_c32(xml)
        end
      end
    end
    
    errors = @result.validate_c32(document.root)
    errors.should be_empty
  end
end
