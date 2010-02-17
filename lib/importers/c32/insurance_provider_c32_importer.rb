class InsuranceProviderC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.9'
  end
  
  def self.entry_xpath
    "cda:entry/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.20']/cda:entryRelationship/cda:act[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.5']"
  end
  
  def self.import_entry(entry_element)
    provider = InsuranceProvider.new
    with_element(entry_element) do |element|
      
      provider.group_number = element.find_first("cda:id/@root").try(:value)
      provider.represented_organization = element.find_first("cda:performer/cda:assignedEntity/cda:representedOrganization/cda:name").try(:text)
      
      type_code = element.find_first("cda:code/@code").try(:value)
      if type_code
        provider.insurance_type = InsuranceType.find_by_code(type_code)
      end
      
      provider.health_plan = element.find_first("cda:entryRelationship[@typeCode='REFR']/cda:act[@classCode='ACT' and @moodCode='DEF']/cda:text").try(:text)
      
      provider.insurance_provider_patient = InsuranceProviderPatient.new
      patient_xpath = "cda:participant[@typeCode='COV']/cda:participantRole[@classCode='PAT']"
      provider.insurance_provider_patient.person_name = PersonNameC32Importer.import(element.find_first(patient_xpath + "/cda:playingEntity/cda:name"))
      provider.insurance_provider_patient.address = AddressC32Importer.import(element.find_first(patient_xpath + "/cda:addr"))
      provider.insurance_provider_patient.telecom = TelecomC32Importer.import(element.find_first(patient_xpath))
      patient_dob = element.find_first(patient_xpath + "/cda:playingEntity/sdtc:birthTime/@value") 
      if patient_dob
        provider.insurance_provider_patient.date_of_birth = patient_dob.to_s.from_hl7_ts_to_date
      end
      provider.insurance_provider_patient.member_id = element.find_first(patient_xpath + "/cda:id/@root").try(:value)
      
      provider.insurance_provider_subscriber = InsuranceProviderSubscriber.new
      subscriber_xpath = "cda:participant[@typeCode='HLD']/cda:participantRole"
      provider.insurance_provider_subscriber.person_name = PersonNameC32Importer.import(element.find_first(subscriber_xpath + "/cda:playingEntity/cda:name"))
      provider.insurance_provider_subscriber.address = AddressC32Importer.import(element.find_first(subscriber_xpath + "/cda:addr"))
      provider.insurance_provider_subscriber.telecom = TelecomC32Importer.import(element.find_first(subscriber_xpath))
      dob = element.find_first(subscriber_xpath + "/cda:playingEntity/sdtc:birthTime/@value") 
      if dob
        provider.insurance_provider_subscriber.date_of_birth = dob.to_s.from_hl7_ts_to_date
      end
      
      provider.insurance_provider_guarantor = InsuranceProviderGuarantor.new
      guarantor_xpath = "cda:performer[cda:assignedEntity/cda:code[@code='' and @codeSystem='']]"
      provider.insurance_provider_guarantor.person_name = PersonNameC32Importer.import(element.find_first(guarantor_xpath + "/cda:assignedEntity/cda:assignedPerson/cda:name"))
      provider.insurance_provider_guarantor.address = AddressC32Importer.import(element.find_first(guarantor_xpath + "/cda:assignedEntity/cda:addr"))
      provider.insurance_provider_guarantor.telecom = TelecomC32Importer.import(element.find_first(guarantor_xpath + "/cda:assignedEntity"))
      role_type = element.find_first(guarantor_xpath + "/cda:assignedEntity/cda:code/@code").try(:value)
      if role_type
        provider.insurance_type = RoleClassRelationshipFormalType.find_by_code(role_type)
      end
      
    end

    provider
  end
end