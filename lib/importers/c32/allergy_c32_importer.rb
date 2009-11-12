class AllergyC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.2'
  end
  
  def self.entry_xpath
    "cda:entry/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']/cda:entryRelationship[@typeCode='SUBJ']/cda:observation[cda:templateId[@root='2.16.840.1.113883.10.20.1.18']]"
  end
  
  def self.import_entry(entry_element)
    allergy = Allergy.new
    with_element(entry_element) do |element|
      start_event_string = element.find_first("cda:effectiveTime/cda:low/@value")
      if start_event_string
        allergy.start_event = start_event_string.to_s.from_hl7_ts_to_date
      end
      
      end_event_string = element.find_first("cda:effectiveTime/cda:high/@value")
      if end_event_string
        allergy.end_event = end_event_string.to_s.from_hl7_ts_to_date
      end
      
      allergy.free_text_product = element.find_first("cda:participant[@typeCode='CSM']/cda:participantRole[@classCode='MANU']/cda:playingEntity[@classCode='MMAT']/cda:name").try(:text)
      allergy.product_code = element.find_first("cda:participant[@typeCode='CSM']/cda:participantRole[@classCode='MANU']/cda:playingEntity[@classCode='MMAT']/cda:code[@codeSystem='2.16.840.1.113883.6.88']/@code").try(:value)
      
      adverse_event_type_code = element.find_first("cda:code/@code")
      
      if adverse_event_type_code
        allergy.adverse_event_type = AdverseEventType.find_by_code(adverse_event_type_code)
      end
      
      # Allergy Status is not constrained by the HITSP C32. To find information on it, you need to look at the HL7 CCD Section 3.8.2.2
      allergy_status_code_code = element.find_first("cda:entryRelationship/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.39']/cda:value/@code")
      if allergy_status_code_code
        allergy.allergy_status_code = AllergyStatusCode.find_by_code(allergy_status_code_code)
      end
    end

    allergy
  end
end