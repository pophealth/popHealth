class RegistrationInformationC32Importer 
  extend ImportHelper
  
  def self.section(document)
    REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget', "cda"=>"urn:hl7-org:v3")
  end
  
  def self.entry_xpath
    "cda:patientRole"
  end
  
  def self.import_entry(entry_element)
    reg_info = RegistrationInformation.new
    
    with_element(entry_element) do |element|
      
      birthday_string = element.find_first("cda:patient/cda:birthTime/@value").try(:value)
      if birthday_string
        reg_info.date_of_birth = birthday_string.to_s.from_hl7_ts_to_date
      end
      
      gender_code = element.find_first("cda:patient/cda:administrativeGenderCode/@code").try(:value)
      if gender_code
        reg_info.gender = Gender.find_by_code(gender_code)
      end
      
      religion_code = element.find_first("cda:patient/cda:religiousAffiliationCode/@code").try(:value)
      if religion_code
        reg_info.religion = Religion.find_by_code(religion_code)
      end
      
      marriage_code = element.find_first("cda:patient/cda:maritalStatusCode/@code").try(:value)
      if marriage_code
        reg_info.marital_status = MaritalStatus.find_by_code(marriage_code)
      end
      
      race_code = element.find_first("cda:patient/cda:raceCode/@code").try(:value)
      if race_code
        reg_info.race = Race.find_by_code(race_code)
      end
      
      ethnicity_code = element.find_first("cda:patient/cda:ethnicGroupCode/@code").try(:value)
      if ethnicity_code
        reg_info.ethnicity = Ethnicity.find_by_code(ethnicity_code)
      end
    end
    
    reg_info
    
  end
end