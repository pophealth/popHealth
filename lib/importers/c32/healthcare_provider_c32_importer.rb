class HealthcareProviderC32Importer 
  extend ImportHelper
  
  def self.section(document)
   REXML::XPath.first(document, '/cda:ClinicalDocument/cda:documentationOf', "cda"=>"urn:hl7-org:v3")
  end
  
  def self.entry_xpath
   "cda:performer[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.4']"
  end
  
  def self.import_entry(entry_element)
    provider = Provider.new
    with_element(entry_element) do |element|
      
      provider.person_name = PersonNameC32Importer.import(element.find_first("cda:assignedEntity/cda:assignedPerson/cda:name"))
      provider.address = AddressC32Importer.import(element.find_first("cda:assignedEntity/cda:addr"))
      provider.telecom = TelecomC32Importer.import(element.find_first("cda:assignedEntity"))
      
      start_time = element.find_first("cda:time/cda:low/@value").try(:value)
      if start_time
        provider.start_service = start_time.to_s.from_hl7_ts_to_date
      end
      
      end_time = element.find_first("cda:time/cda:high/@value").try(:value)
      if end_time
        provider.end_service = end_time.to_s.from_hl7_ts_to_date
      end
      
      provider_role_code = element.find_first("cda:functionCode/@code").try(:value)
      if provider_role_code
        provider.provider_role = ProviderRole.find_by_code(provider_role_code)
      end
      
      provider_type_code = element.find_first("cda:assignedEntity/cda:code/@code").try(:value)
      if provider_type_code
        provider.provider_type = ProviderType.find_by_code(provider_type_code)
      end
      
      provider.patient_identifier = element.find_first("sdtc:patient/sdtc:id/@root").try(:value)
      
      provider.organization = element.find_first("cda:representedOrganization/cda:name").try(:text)
      
    end

    provider
  end
end