class AtnaAuditsController < ApplicationController

  page_title 'ATNA Message Logs'

  def index
    @atna_audits = AtnaAudit.paginate :page => params[:page], :order => 'timestamp_entry DESC', :per_page => 1

    @values = []
    @element_name =[]
    return if @atna_audits.empty?

    begin
      # XXX It looks like the original authors included this java validation
      # portion in order to catch and report an invalid message.
      require 'java'
      schemaFile = java.io.File.new(File.join(RAILS_ROOT, "public", "schemas", "atna_audit.xsd"))

      factory = javax.xml.validation.SchemaFactory.newInstance("http://www.w3.org/2001/XMLSchema")
      schema = factory.newSchema(schemaFile)
      validator = schema.newValidator()
      domFactory = javax.xml.parsers.DocumentBuilderFactory.newInstance()
      domFactory.setNamespaceAware(true)
      builder = domFactory.newDocumentBuilder()
      docu = builder.parse(java.io.ByteArrayInputStream.new(@atna_audits[0].message.to_java_bytes))
      source = javax.xml.transform.dom.DOMSource.new(docu)
      result = javax.xml.transform.dom.DOMResult.new()
      validator.validate(source, result)
    rescue org.xml.sax.SAXParseException => ex
      @notice = "Error: ATNA log message is not valid."
      return
    end

    doc = REXML::Document.new(@atna_audits[0].message)

    doc.elements.each("AuditMessage/EventIdentification") { |element|
      @element_name << "Event Date Time :"
      @values << element.attributes["EventDateTime"]
    }
    doc.elements.each("AuditMessage/EventIdentification/EventTypeCode") { |element|
      @element_name << "Event Code :"
      @values << element.attributes["code"]
      @element_name << "Code System Name"
      @values << element.attributes["codeSystemName"]
      @element_name << "Event Type :"
      @values << element.attributes["displayName"]
    }
      @element_name << ""
      @values << ""
    doc.elements.each("AuditMessage/ActiveParticipant") { |element|
      @element_name << "Network Access Point ID :"
      @values << element.attributes["NetworkAccessPointID"]
      @element_name << "Network Access Point Type Code"
      @values << element.attributes["NetworkAccessPointTypeCode"]
    }
    doc.elements.each("AuditMessage/ParticipantObjectIdentification") { |element|
      @element_name << "Participant Object ID"
      @values << element.attributes["ParticipantObjectID"]
    }
    doc.elements.each("AuditMessage/ParticipantObjectIdentification/ParticipantObjectName") { |element|
      @element_name << "Participant Object Name"
      @values << element.text

    }
    doc.elements.each("AuditMessage/ParticipantObjectIdentification/ParticipantObjectDetail") { |element|
      @element_name << "Participant Object Detail Type"
      @values << element.attributes["type"]
      @element_name << "Participant Object Detail Value"
      @values << element.attributes["value"]
    }

  rescue REXML::ParseException
    # XXX the java validation check probably short-circuits this possibility
    @element_name  << "Unable to Parse Message"
    @values << "Unable to Parse Message"
  rescue RuntimeError => ex # XXX should be catching the corresponding java exception, not RuntimeError
    @notice = "Could not access the ATNA database. " + ex.to_s.sub("org.postgresql.util.PSQLException: ", "")
  end
end
