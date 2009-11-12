require File.dirname(__FILE__) + '/../spec_helper'

describe AdvanceDirective, "can validate itself" do
  
  fixtures :advance_directives, :advance_directive_types
  
  before(:each) do
    @ad = advance_directives(:jennifer_thompson_advance_directive)
  end  
  
  it "should validate without errors" do
    # this will add the validate_c32 
    
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/advance_directive/jenny_advance_directive.xml'))
    errors = @ad.validate_c32(document.root)
    errors.should be_empty
  end 
end

describe AdvanceDirective, "can create a C32 representation of itself" do
  fixtures :advance_directives, :advance_directive_types, :advance_directive_status_codes

  
  it "should create valid C32 content" do
    ad = advance_directives(:jennifer_thompson_advance_directive)
    document = LaikaSpecHelper.build_c32 do |xml|
      ad.to_c32(xml)
    end
    errors = ad.validate_c32(document.root)
    errors.should be_empty
  end
end
