class AdvanceDirectiveC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.1'
  end
  
  def self.entry_xpath
    "cda:entry/cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.13' or cda:templateId/@root='2.16.840.1.113883.10.20.1.17']"
  end
  
  def self.import_entry(entry_element)
    directive = AdvanceDirective.new
    with_element(entry_element) do |element|
      
      directive.person_name = PersonNameC32Importer.import(element.find_first("cda:participant/cda:participantRole/cda:playingEntity/cda:name"))
      directive.address = AddressC32Importer.import(element.find_first("cda:participant/cda:participantRole/cda:addr"))
      directive.telecom = TelecomC32Importer.import(element.find_first("cda:participant/cda:participantRole"))
      
      start_time = element.find_first("cda:effectiveTime/cda:low/@value").try(:value)
      if start_time
        directive.start_effective_time = start_time.to_s.from_hl7_ts_to_date
      end
      
      end_time = element.find_first("cda:effectiveTime/cda:high/@value").try(:value)
      if end_time
        directive.end_effective_time = end_time.to_s.from_hl7_ts_to_date
      end
      
      directive.free_text = deref(element.find_first("cda:code/cda:originalText")).try(:value)
      
      directive_type = element.find_first("cda:code/@code").try(:value)
      if directive_type
        directive.advance_directive_type = AdvanceDirectiveType.find_by_code(directive_type)
      end
      
      directive_status = element.find_first("cda:entryRelationship/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.37']/cda:value/@code").try(:value)
      if directive_status
        directive.advance_directive_status_code = AdvanceDirectiveStatusCode.find_by_code(directive_status)
      end
    end

    directive
  end
end