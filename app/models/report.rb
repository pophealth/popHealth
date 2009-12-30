class Report < ActiveRecord::Base
  
  def numerator_query=(val)
    @numerator_query = val
  end

  def denominator_query=(val)
    @denominator_query = val
  end

  def numerator_query
    self[:numerator_query].present? ? @numerator_query ||= YAML.load(self[:numerator_query]) : @numerator_query ||= {}  
    @numerator_query
  end

  def denominator_query
    self[:denominator_query].present? ? @denominator_query ||= YAML.load(self[:denominator_query]) : @denominator_query ||= {}
    @denominator_query
  end

  def save(*args)
    self[:denominator_query] = YAML.dump(denominator_query)
    self[:numerator_query] = YAML.dump(numerator_query)
    super(args)
  end
  
  def to_json_hash
    {:title => self.title, :numerator => self.numerator, :denominator => self.denominator, :id => self.id,
      :numerator_fields => self.numerator_query, :denominator_fields => self.denominator_query}
  end
  
  def to_json(*args)
    to_json_hash.to_json
  end

  # Build a PQRI document representing the report.
  #
  # @return [Builder::XmlMarkup] PQRI representation of report data
  def to_pqri(pqri_xml = nil)
    pqri_xml ||= Builder::XmlMarkup.new(:indent => 2)
    pqri_xml.submission("type" => "PQRI-REGISTRY", "option" => "PAYMENT", "version" => "1.0",
    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
    "xsi:noNamespaceSchemaLocation" => "Registry_Payment.xsd") {

      pqri_xml.tag!('file-audit-data') {
        pqri_xml.tag! :'create-date', DateTime.now.strftime("%m-%d-%Y")
        pqri_xml.tag! :'create-time', DateTime.now.strftime("%H:%M")
        pqri_xml.tag! :'create-by', "popHealth"
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
            pqri_xml.tag! :'pqri-measure-number', self.id
            pqri_xml.tag! :'eligible-instances', self.denominator
            pqri_xml.tag! :'meets-performance-instances', self.numerator
            pqri_xml.tag! :'performance-exclusion-instances', 0
            pqri_xml.tag! :'performance-not-met-instances', (self.denominator - self.numerator)
            pqri_xml.tag! :'reporting-rate', "100.00"
            pqri_xml.tag! :'performance-rate', Float.induced_from(self.numerator) / Float.induced_from(self.denominator) * 100
          end
        }
      end
    }
  end

end