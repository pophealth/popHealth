class Report < ActiveRecord::Base
  
  # Build a PQRI document representing the report.
  #
  # @return [Builder::XmlMarkup] PQRI representation of report data
  def to_pqri(pqri_xml = nil)
    pqri_xml ||= Builder::XmlMarkup.new(:indent => 2)
    pqri_xml.instruct!
    pqri_xml.submission("type" => "PQRI-REGISTRY", "option" => "PAYMENT", "version" => "1.0",
                        "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
                        "xsi:noNamespaceSchemaLocation" => "Registry_Payment.xsd") {
      pqri_xml.fileauditdata {
        
      }
      pqri_xml.registry {
        
      }
      pqri_xml.measuregroup("ID" => "X") {
        pqri_xml.provider {

        }
        
      }
    }
    pqri_xml

  end

end