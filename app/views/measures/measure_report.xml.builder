@report ||= report ||= nil
xml.instruct!
xml.submission(
  "type" => "PQRI-REGISTRY", "option" => "PAYMENT", "version" => "3.0",
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xsi:noNamespaceSchemaLocation" => "Registry_Payment.xsd") do

  xml.tag!('file-audit-data') do
    xml.tag! :'create-date', DateTime.now.strftime("%m-%d-%Y")
    xml.tag! :'create-time', DateTime.now.strftime("%H:%M")
    xml.tag! :'create-by', "popHealth"
    xml.tag! :version, "1.0"
    xml.tag! :'file-number', "1"
    xml.tag! :'number-of-files', "1"
  end

  xml.registry do
    xml.tag! :'registry-name', @report[:registry_name] 
    xml.tag! :'registry-id', @report[:registry_id]
    xml.tag! :'submission-method', "A"
  end

  xml.tag! :'measure-group', "ID" => "X" do
    @report[:provider_reports].each do |provider_report|
    xml.provider do
      xml.npi(provider_report[:npi])
      xml.tin(provider_report[:tin])
      xml.tag! :'waiver-signed', "Y"
      xml.tag! :'encounter-from-date', provider_report[:start].strftime("%m-%d-%Y")
      xml.tag! :'encounter-to-date', provider_report[:end].strftime("%m-%d-%Y")
      provider_report[:results].each do |result|
        xml.tag! :'pqri-measure' do
          xml.tag! :'pqri-measure-number', result[:id]+result[:sub_id].to_s
          xml.tag! :'collection-method', 'A'
          xml.tag! :'eligible-instances', result[:denominator] + result[:exclusions]
          xml.tag! :'meets-performance-instances', result[:numerator]
          xml.tag! :'performance-exclusion-instances', result[:exclusions]
          xml.tag! :'performance-not-met-instances', (result[:denominator] - result[:numerator])
          xml.tag! :'reporting-rate', "100.00"
          xml.tag! :'performance-rate', "%.2f" % (100.0 * result[:numerator] / (result[:denominator]))
        end
      end
    end
    end
  end
end

