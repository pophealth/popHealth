class EncounterC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.3'
  end
  
  def self.entry_xpath
    "cda:entry/cda:encounter[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.17']"
  end
  
  def self.import_entry(entry_element)
    encounter = Encounter.new
    with_element(entry_element) do |element|
      
      encounter.person_name = PersonNameC32Importer.import(element.find_first("cda:participant[@typeCode='PRF']/cda:participantRole[@classCode='PROV']/cda:playingEntity/cda:name"))
      encounter.address = AddressC32Importer.import(element.find_first("cda:participant[@typeCode='PRF']/cda:participantRole[@classCode='PROV']/cda:addr"))
      encounter.telecom = TelecomC32Importer.import(element.find_first("cda:participant[@typeCode='PRF']/cda:participantRole[@classCode='PROV']"))
      
      encounter.encounter_id = element.find_first("cda:id/@root").try(:value) 
      encounter.free_text = element.find_first("cda:code/cda:originalText").try(:text)
      # encounter.name -- currently not structured in Laika-produced C32 XML
      
      enc_date = element.find_first("cda:effectiveTime/cda:low/@value")
      if enc_date
        encounter.encounter_date = enc_date.to_s.from_hl7_ts_to_date
      end
      
      enc_loc_code = element.find_first("cda:participant[@typeCode='LOC']/cda:participantRole[@classCode='SDLOC']/cda:code/@code").try(:value)
      if enc_loc_code
        encounter.encounter_location_code = EncounterLocationCode.find_by_code(enc_loc_code)
      end
      
      enc_type_code = element.find_first("cda:code/@code").try(:value)
      if enc_type_code
        encounter.encounter_type = EncounterType.find_by_code(enc_type_code)
      end
      
    end

    encounter
  end
end