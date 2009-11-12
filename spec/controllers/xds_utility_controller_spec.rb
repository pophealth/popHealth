require File.dirname(__FILE__) + '/../spec_helper'

describe XdsUtilityController do
   fixtures :patient_identifiers, :patients
   
  before { controller.stub!(:current_user).and_return mock_model(User) }
  


  
  it "should return all patients created as an array of XDSRecords" do
    XdsRecordUtility.should_receive(:documents).with(
                                            'urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446',
                                            '1234567890^^^CCHIT&1.2.3.4.5.6.7.8.9&ISO').and_return(['urn:uuid:265e5f4e-9723-4d34-bfa6-f709cb92abbb'])
    
    XdsRecordUtility.should_receive(:all_identifiers).and_return([{ 'identificationscheme' => 'urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446',
                                                              'value' => '1234567890^^^CCHIT&1.2.3.4.5.6.7.8.9&ISO',
                                                              'id' => 'urn:uuid:c5fab40b-9e16-4a30-8c19-c11387d4ab56' }])                                        
    get :index
    response.should be_success
  end
  
 

end

