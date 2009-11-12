require File.dirname(__FILE__) + '/../spec_helper'

describe XdsRecordUtility do
  
  fixtures :patient_identifiers, :patients
  
  before(:each) do
    #prep our comparison
    @patients = []
    @patients << XdsRecordUtility::XDSRecord.new
    @patients[0].documents = ['urn:uuid:265e5f4e-9723-4d34-bfa6-f709cb92abbb']
    @patients[0].value = '1234567890^^^CCHIT&1.2.3.4.5.6.7.8.9&ISO'
    @patients[0].id = 'urn:uuid:c5fab40b-9e16-4a30-8c19-c11387d4ab56'
    @patients[0].id_scheme = 'urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446'
    @patients[0].patient = Patient.find_by_patient_identifier( '1234567890^^^CCHIT&1.2.3.4.5.6.7.8.9&ISO' )
  end
  

  
  
  it "should return all patients created as an array of XDSRecords" do
    XdsRecordUtility.should_receive(:documents).with(
                                            'urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446',
                                            '1234567890^^^CCHIT&1.2.3.4.5.6.7.8.9&ISO').and_return(['urn:uuid:265e5f4e-9723-4d34-bfa6-f709cb92abbb'])
    
    XdsRecordUtility.should_receive(:all_identifiers).and_return([{ 'identificationscheme' => 'urn:uuid:6b5aea1a-874d-4603-a4bc-96a0a7b38446',
                                                              'value' => '1234567890^^^CCHIT&1.2.3.4.5.6.7.8.9&ISO',
                                                              'id' => 'urn:uuid:c5fab40b-9e16-4a30-8c19-c11387d4ab56' }])                                        
    
    XdsRecordUtility.all_patients.should == @patients
  end
  
  it "should return an empty set of XDSRecords" do
    XdsRecordUtility.should_receive(:all_identifiers).and_return( [] )
    ap = XdsRecordUtility.all_patients          
    ap.should eql( [] )  
  end
  
 
  
end
