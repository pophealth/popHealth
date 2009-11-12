require File.dirname(__FILE__) + '/../spec_helper'

describe PersonName do
  it 'should be blank if all fields are empty' do
    PersonName.new.should be_blank
  end

  %w[
    name_prefix first_name last_name name_suffix
  ].each do |attr|
    it "should not be blank if #{attr} field is not empty" do
      PersonName.new(attr => "0").should_not be_blank
    end
  end

end
