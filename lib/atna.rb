require 'syslog'
require 'builder'

# Class for logging messages to syslog using the XML format defined in
# RFC3881. This allows for the support of IHE ATNA Record Audit
class Atna

  # Outcome event outcome identifiers specified in RFC3881
  # section 5.1.4
  MINOR_FAILURE = 4
  SUCCESS = 0

  # Write a message to syslog in RFC3881 format
  def self.log(username, event)
    with_syslog do |sl|
      sl.notice(generate_xml(username, event))
    end
  end

  # Generates a String that contains the RFC3881 formatted
  # log message
  # @param [String] username The name of the user to pass into the log
  # @param [Symbol] event The event that is being logged. :login_failure will cause a minor failure
  #                       outcome identifier to be generated. All other symbols will result in
  #                       success
  def self.generate_xml(username, event)
    builder = Builder::XmlMarkup.new
    xml = builder.AuditMessage do
      builder.EventIdentification('EventDateTime' => Time.now.xmlschema, 'EventOutcomeIndicator' => outcome_for_event(event)) do
        builder.EventID('code' => event.to_s, 'displayName' => 'popHealth Codes', 'originalText' => event.to_s)
      end
      builder.ActiveParticipant('UserID' => username)
      builder.AuditSourceIdentification('AuditSourceID' => 'popHealth')
    end
    xml
  end

  private

  def self.with_syslog
    s = Syslog.open('popHealth', Syslog::LOG_PID | Syslog::LOG_CONS, Syslog::LOG_AUTH)
    yield s
    s.close
  end

  def self.outcome_for_event(event)
    if event.eql? :login_failure
      MINOR_FAILURE
    else
      SUCCESS
    end
  end

end