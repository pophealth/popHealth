require File.dirname(__FILE__) + '/../spec_helper'

describe Encounter, "can generate random values for itself" do
  fixtures :iso_countries, :zip_codes, :encounter_types, :encounter_location_codes
  it 'should create a valid Encounter when randomized' do
    encounter = Encounter.new
    encounter.randomize(Date.parse('1978-06-05'))
    
    encounter.encounter_date.should_not be_nil
    encounter.person_name.should_not be_nil
    encounter.telecom.should_not be_nil
    encounter.address.should_not be_nil
    encounter.encounter_id.should_not be_nil
    encounter.name.should_not be_nil
    encounter.free_text.should_not be_nil
    encounter.location_name.should_not be_nil
    encounter.encounter_location_code.should_not be_nil
  end
end
