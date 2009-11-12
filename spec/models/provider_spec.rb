require File.dirname(__FILE__) + '/../spec_helper'
  
describe Provider do
  fixtures :providers,:provider_roles,:provider_types, :person_names, :telecoms, :addresses
  
  before(:each) do
    @provider = providers(:rn_mary_smith)
  end  

  it "should require start/end service" do
    pending "SF ticket 2119631"
    @provider.update_attributes!(:start_service => nil, :end_service => nil)
    document = document_for(@provider)
    @provider.validate_c32(document).should_not be_empty
  end                   
  
  it "should validate itself without errors" do
    document = REXML::Document.new(File.new(RAILS_ROOT + '/spec/test_data/jenny_healthcare_provider.xml'))
    @provider.validate_c32(document).should be_empty
  end 
  

  it "should create valid C32 content" do
    document = document_for(@provider)
    @provider.validate_c32(document).should be_empty
  end

  #
  # helpers
  #
  def document_for(provider)
    LaikaSpecHelper.build_c32 do |xml|
      xml.documentationOf do 
        xml.serviceEvent("classCode" => "PCPR") do 
          xml.effectiveTime  do
            xml.low('value'=> "0")
            xml.high('value'=> "2010")
          end     
        provider.to_c32(xml)
        end 
      end
    end
  end


end
