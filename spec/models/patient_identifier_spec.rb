require File.dirname(__FILE__) + '/../spec_helper'

describe PatientIdentifier do
  fixtures :patient_identifiers

  describe "testing patient identifier to patient" do
    before(:each) do
      @patient_id = PatientIdentifier.new(
        :patient_identifier => '1234',
        :affinity_domain => 'BOBFOO'
      )
    end

    it "should assemble an identifier string" do
      @patient_id.identifier_and_domain.should == '1234^^^BOBFOO'
    end

  end
end
