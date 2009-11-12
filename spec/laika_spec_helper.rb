module LaikaSpecHelper
  # Helps easily build a C32 document. A builder object will be pased into the block passed into the object
  # Will puts the full XML doc if debug is set to true when called
  def self.build_c32(debug=false)
    buffer = ""
    xml = Builder::XmlMarkup.new(:target => buffer, :indent => 2)
    xml.ClinicalDocument("xsi:schemaLocation" => "urn:hl7-org:v3 http://xreg2.nist.gov:8080/hitspValidation/schema/cdar2c32/infrastructure/cda/C32_CDA.xsd", 
                         "xmlns" => "urn:hl7-org:v3", 
                         "xmlns:sdct" => "urn:hl7-org:sdct", 
                         "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance") do
      yield xml
    end
    puts buffer if debug
    REXML::Document.new(StringIO.new(buffer))
  end
end