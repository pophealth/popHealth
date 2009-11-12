require File.dirname(__FILE__) + '/../../../spec_helper'

describe AllergyC32Importer do
  it "should import an allergy entry in a C32 into an ActiveRecord object" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/allergies/joe_allergy.xml'))

    section = AllergyC32Importer.section(document)
    allergies = AllergyC32Importer.import_entries(section)
    allergy = allergies.first
    allergy.start_event.should.eql? Date.civil(2006, 2, 21)
    allergy.free_text_product.should == 'Penicillin'
    allergy.product_code.should == '70618'
  end
end