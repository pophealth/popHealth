require File.dirname(__FILE__) + '/../spec_helper'

describe Address do

  it 'should be blank if all fields are empty' do
    Address.new.should be_blank
  end

  %w[
    street_address_line_one street_address_line_two
    city state postal_code iso_country_id
  ].each do |attr|
    it "should not be blank if #{attr} field is not empty" do
      Address.new(attr => "0").should_not be_blank
    end
  end

  describe "after randomize()" do
    fixtures :iso_countries, :zip_codes

    before do
      (@address = Address.new).randomize
    end
  
    it 'should be fully populated' do
      @address.street_address_line_one.should_not be_blank
      @address.city.should_not be_blank
      @address.state.should_not be_blank
      @address.postal_code.should_not be_blank
      @address.iso_country.should == iso_countries(:usa)
    end
  end

end
