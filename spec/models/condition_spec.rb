require File.dirname(__FILE__) + '/../spec_helper'

describe Condition, "can validate itself" do
  fixtures :conditions, :problem_types
  
  before(:each) do
    @cond = conditions(:joes_condition)
  end  
  
  it "should validate without errors" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/conditions/joes_condition.xml'))
    errors = @cond.validate_c32(document.root)
    #puts errors.map{|e| e.error_message}.join(' ') 
    errors.should be_empty
  end 
end

describe Condition, "can create a C32 representation of itself" do
  fixtures :conditions, :problem_types


  
  it "should create valid C32 content" do
    cond = conditions(:joes_condition)
    
    document = LaikaSpecHelper.build_c32 do |xml|

        xml.component {
          xml.structuredBody {
            xml.component {
              xml.section {
                xml.templateId("root" => "2.16.840.1.113883.10.20.1.11", 
                               "assigningAuthorityName" => "CCD")
                xml.code("code" => "11450-4", 
                         "displayName" => "Problems", 
                         "codeSystem" => "2.16.840.1.113883.6.1", 
                         "codeSystemName" => "LOINC")
                xml.title "Conditions or Problems"
                xml.text {
                  xml.content(cond.free_text_name, "ID" => "problem-"+cond.id.to_s) 
                }
                
                cond.to_c32(xml)
              }
            }
          }
        }
       
    end
    
    errors = cond.validate_c32(document.root)
    errors.should be_empty
  end
end
