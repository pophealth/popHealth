require File.dirname(__FILE__) + '/../spec_helper'
 
describe InsuranceProvider, "it can validate insurance provider entries in a C32" do
  fixtures :insurance_providers, :insurance_types, :coverage_role_types, :role_class_relationship_formal_types, :insurance_provider_guarantors, :insurance_provider_patients, :insurance_provider_subscribers

  it "should verify an insurance provider matches in a C32 doc" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/insurance_provider/insurance_provider.xml'))
    joe_insurance_provider = insurance_providers(:joe_smiths_insurance_provider)
    errors = joe_insurance_provider.validate_c32(document.root)
    #puts errors.map { |e| e.error_message }.join(' ')
    errors.should be_empty
  end
  
end

describe InsuranceProvider, "can create a C32 representation of itself" do
  fixtures :insurance_providers, :insurance_type, :coverage_role_type, :role_class_relationship_formal_type
  
  
end
