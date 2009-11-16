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
      
      pqri_xml.tag!('file-audit-data') {
         pqri_xml.tag! :'create-date', DateTime.now.strftime("%m-%d-%Y")
         pqri_xml.tag! :'create-time', DateTime.now.strftime("%H:%M")
         pqri_xml.tag! :'create-by', "popQuality"
         pqri_xml.tag! :version, "1.0"
         pqri_xml.tag! :'file-number', "1"
         pqri_xml.tag! :'number-of-files', "1"
    }
      
      pqri_xml.registry {
        pqri_xml.tag! :'registry-name', "Example Registry"
        pqri_xml.tag! :'registry-id', "000-exampleRegistryId"
        pqri_xml.tag! :'submission-period-from-date', "01-01-2009"
        pqri_xml.tag! :'submission-period-to-date', DateTime.now.strftime("%m-%d-%Y")
        pqri_xml.tag! :'submission-method', "A"
      }
      
      pqri_xml.tag! :'measure-group', "ID" => "X" do
        pqri_xml.provider {
          pqri_xml.npi("1234567890")
    			pqri_xml.tin("Tax Id #")
    			pqri_xml.tag! :'waiver-signed', "Y"
    			pqri_xml.tag! :'pqri-measure' do
    				pqri_xml.tag! :'pqri-measure-number'
    				pqri_xml.tag! :'eligible-instances'          # denominator
    				pqri_xml.tag! :'meets-performance-instances' # numerator 
    				pqri_xml.tag! :'performance-exclusion-instances'
    				pqri_xml.tag! :'performance-not-met-instances'
    				pqri_xml.tag! :'reporting-rate'
    				pqri_xml.tag! :'performance-rate'
  				end
        }
      end
    }
    pqri_xml

  end

end