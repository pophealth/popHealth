class SupportC32Importer 
  extend ImportHelper
  
  def self.section(document)
   REXML::XPath.first(document, '/cda:ClinicalDocument', "cda"=>"urn:hl7-org:v3")
  end
  
  def self.entry_xpath
   'cda:participant'
  end
  
  def self.import_entry(entry_element)
    support = Support.new
    with_element(entry_element) do |element|
      
      support.person_name = PersonNameC32Importer.import(element.find_first("cda:associatedEntity/cda:associatedPerson/cda:name"))
      support.address = AddressC32Importer.import(element.find_first("cda:associatedEntity/cda:addr"))
      support.telecom = TelecomC32Importer.import(element.find_first("cda:associatedEntity"))
      
      start_time = element.find_first("cda:time/cda:low/@value").try(:value)
      if start_time
        support.start_support = start_time.to_s.from_hl7_ts_to_date
      end
      
      end_time = element.find_first("cda:time/cda:high/@value").try(:value)
      if end_time
        support.end_support = end_time.to_s.from_hl7_ts_to_date
      end
      
      contact = element.find_first("cda:associatedEntity/@classCode").try(:value)
      if contact
        support.contact_type = ContactType.find_by_code(contact)
      end
      
      relationship = element.find_first("cda:associatedEntity/cda:code/@code").try(:value)
      if relationship
        support.relationship = Relationship.find_by_code(relationship)
      end
    end

    support
  end
end