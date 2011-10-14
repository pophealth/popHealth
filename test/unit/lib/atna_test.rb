require 'test_helper'

class AtnaTest < ActiveSupport::TestCase
  test "should generate valid XML for login" do
    xml = Atna.generate_xml('joe_user', :login)
    doc = Nokogiri::XML(xml)
    assert_equal 'login', doc.at_xpath('/AuditMessage/EventIdentification/EventID')['code']
    assert_equal '0', doc.at_xpath('/AuditMessage/EventIdentification')['EventOutcomeIndicator']
    assert_equal 'joe_user', doc.at_xpath('/AuditMessage/ActiveParticipant')['UserID']
  end
  
  test "should generate valid XML for login failure" do
    xml = Atna.generate_xml('joe_user', :login_failure)
    doc = Nokogiri::XML(xml)
    assert_equal 'login_failure', doc.at_xpath('/AuditMessage/EventIdentification/EventID')['code']
    assert_equal '4', doc.at_xpath('/AuditMessage/EventIdentification')['EventOutcomeIndicator']
  end
end