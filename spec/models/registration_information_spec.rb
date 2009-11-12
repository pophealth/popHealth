require File.dirname(__FILE__) + '/../spec_helper'

describe RegistrationInformation, "can vaildate it's content" do
  fixtures :patients, :registration_information, :person_names, :addresses,
           :telecoms, :genders, :marital_statuses, :ethnicities, :races, :religions,
           :patient_identifiers
 
  it "should verify a person id matches in a C32 doc" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/joe_c32.xml'))
    joe_reg = registration_information(:joe_smith)
    errors = joe_reg.validate_c32(document)
    #puts errors.map {|e| e.error_message }.join(' ')
    errors.should be_empty
  end
end

describe RegistrationInformation, "can create a C32 representation of itself" do
  fixtures :patients, :registration_information, :person_names, :addresses,
           :telecoms, :genders, :marital_statuses, :ethnicities, :races, :religions,
           :patient_identifiers

   
  it "should create valid C32 content" do
    joe_reg = registration_information(:joe_smith)
    
    document = LaikaSpecHelper.build_c32 do |xml|
      xml.recordTarget do
        xml.patientRole do
          joe_reg.to_c32(xml)
        end
      end
    end

    errors = joe_reg.validate_c32(document.root)
    errors.should be_empty
  end
end
