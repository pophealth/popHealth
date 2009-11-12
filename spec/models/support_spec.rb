require File.dirname(__FILE__) + '/../spec_helper'

describe Support do
  fixtures :relationships, :contact_types, :person_names,
           :addresses, :telecoms, :iso_countries, :supports


  it "should generate valid c32 with guardian type" do
    pending "SF ticket 2539006"
    support = Support.new(
      :start_support => Date.civil(1981,11,05),
      :end_support => Date.civil(2010,02,13),
      :contact_type => contact_types(:guardian),
      :relationship => relationships(:father),
      :address => Address.find(:first),
      :person_name => PersonName.new(:first_name => 'Harry', :last_name => 'Manchester')
    )
    document = LaikaSpecHelper.build_c32 do |xml|
      support.to_c32(xml)
    end
    support.validate_c32(document).should be_empty
  end
           

  it "should verify a support matches in a C32 document" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/supports/jenny_support.xml'))
    support = supports(:jennifer_thompson_husband)
    errors = support.validate_c32(document.root)
    errors.should be_empty
  end

  it "should create valid C32 content" do
    support = supports(:jennifer_thompson_husband)
    
    document = LaikaSpecHelper.build_c32 do |xml|
      support.to_c32(xml)
    end
    
    errors = support.validate_c32(document.root)
    errors.should be_empty
  end
end
