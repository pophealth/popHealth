require File.dirname(__FILE__) + '/../spec_helper'

describe Allergy, "it can validate allergy entries in a C32" do
  fixtures :allergies, :severity_terms, :adverse_event_types
  

  
  it "should verify an allergy matches in a C32 doc" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/allergies/joe_allergy.xml'))
    section = AllergyC32Importer.section(document)
    xml_allergies = AllergyC32Importer.import_entries(section)
    joe_allergy = allergies(:joes_allergy)
    errors = joe_allergy.validate_c32(xml_allergies)
    errors.should be_empty
  end
  
  it "should verify when there are no known allergies" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/allergies/no_known_allergies.xml'))
    allergy = Allergy.new
    errors = allergy.check_no_known_allergies_c32(document)
    errors.should be_empty
  end
end

describe Allergy, "can create a C32 representation of itself" do
  fixtures :allergies, :severity_terms, :adverse_event_types
  
 
  it "should create valid C32 content" do
    joe_allergy = allergies(:joes_allergy)
    
    document = LaikaSpecHelper.build_c32 do |xml|
       xml.component do
         xml.structuredBody do
             xml.component do
               xml.section do
                 xml.templateId("root" => "2.16.840.1.113883.10.20.1.2", 
                                "assigningAuthorityName" => "CCD")
                 xml.code("code" => "48765-2", 
                          "codeSystem" => "2.16.840.1.113883.6.1")
                 xml.title "Allergies, Adverse Reactions, Alerts"
                 xml.text do
                   xml.table("border" => "1", "width" => "100%") do
                     xml.thead do
                       xml.tr do
                         xml.th "Substance"
                         xml.th "Event Type"
                         xml.th "Severity"
                       end
                     end
                     xml.tbody do
                       xml.tr do
                         if joe_allergy.free_text_product != nil
                           xml.td joe_allergy.free_text_product
                         else
                           xml.td
                         end 
                         if joe_allergy.adverse_event_type != nil
                           xml.td joe_allergy.adverse_event_type.name
                         else
                           xml.td
                         end  
                         if joe_allergy.severity_term != nil
                           xml.td do
                             xml.content(joe_allergy.severity_term.name, 
                                         "ID" => "severity-" + joe_allergy.id.to_s)
                           end
                         else
                           xml.td
                         end  
                       end

                     end
                   end
                 end

                 # Start structured XML
                 joe_allergy.to_c32(xml)
                 # End structured XML
               end
             end
         end
           
       end
    end
    section = AllergyC32Importer.section(document)
    xml_allergies = AllergyC32Importer.import_entries(section)
    errors = joe_allergy.validate_c32(xml_allergies)
    errors.should be_empty
  end
end
