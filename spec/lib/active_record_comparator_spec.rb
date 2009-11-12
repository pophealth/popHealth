require File.dirname(__FILE__) + '/../spec_helper'

describe ActiveRecordComparator do
  it "should be able to filter a list of attributes to get ones relevant for comparison" do
    attr_list = ['user_id', 'id', 'created_on', 'updated_at', 'cheese', 'bacon', 'zombie_id', 'splendid']
    filtered_list = ActiveRecordComparator.filter_attributes(attr_list)
    filtered_list.should_not be_nil
    filtered_list.should include('cheese', 'bacon', 'splendid')
    filtered_list.should_not include('user_id', 'id', 'created_on', 'updated_at', 'zombie_id')
  end
  
  describe 'when comparing records' do
    it 'should return nil when attributes are equal' do
      allergy_a = Allergy.factory.create(:free_text_product => 'Penicillin', :patient => Patient.factory.create)
      allergy_b = Allergy.factory.create(:free_text_product => 'Penicillin', :patient => Patient.factory.create)
      
      result = ActiveRecordComparator.compare(allergy_a, allergy_b)
      result.should be_nil
    end
    
    it 'should return an error when an attribute is present in A but not it B' do
      allergy_a = Allergy.factory.create(:free_text_product => 'Penicillin', :patient => Patient.factory.create)
      allergy_b = Allergy.factory.create(:patient => Patient.factory.create)
      
      result = ActiveRecordComparator.compare(allergy_a, allergy_b)
      result.should_not be_nil
    end
    
    it 'should return an error when an attribute in A does not match an attribute in B' do
      allergy_a = Allergy.factory.create(:free_text_product => 'Penicillin', :patient => Patient.factory.create)
      allergy_b = Allergy.factory.create(:free_text_product => 'Cheese', :patient => Patient.factory.create)
      
      result = ActiveRecordComparator.compare(allergy_a, allergy_b)
      result.should_not be_nil
      result.first.section.should == 'Allergy'
      result.first.field_name.should == 'Free text product'
      result.first.error_message.should == "Expected Penicillin, but found Cheese"
    end
    
    it 'should return nil when an attribute is not present in A but is present in B' do
      allergy_a = Allergy.factory.create(:patient => Patient.factory.create)
      allergy_b = Allergy.factory.create(:free_text_product => 'Penicillin', :patient => Patient.factory.create)
      
      result = ActiveRecordComparator.compare(allergy_a, allergy_b)
      result.should be_nil
    end
  end
end