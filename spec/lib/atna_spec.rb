require 'spec_helper'

describe Atna do
  it "should generate valid XML for login" do
    xml = Atna.generate_xml('joe_user', :login)
    doc = Nokogiri::XML(xml)
    doc.at_xpath('/AuditMessage/EventIdentification/EventID')['code'].should == 'login'
    doc.at_xpath('/AuditMessage/EventIdentification')['EventOutcomeIndicator'].should == '0'
    doc.at_xpath('/AuditMessage/ActiveParticipant')['UserID'].should == 'joe_user'
  end
  
  it "should generate valid XML for login failure" do
    xml = Atna.generate_xml('joe_user', :login_failure)
    doc = Nokogiri::XML(xml)
    doc.at_xpath('/AuditMessage/EventIdentification/EventID')['code'].should == 'login_failure'
    doc.at_xpath('/AuditMessage/EventIdentification')['EventOutcomeIndicator'].should == '4'
  end
end