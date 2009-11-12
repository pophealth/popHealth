class PatientC32Importer
  
  def self.import_c32(clinical_document) 
    first_name_element = REXML::XPath.first(clinical_document, 
                                    "/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:given",
                                    {'cda' => 'urn:hl7-org:v3'})
    last_name_element = REXML::XPath.first(clinical_document, 
                                   "/cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:name/cda:family",
                                   {'cda' => 'urn:hl7-org:v3'})
    
    patient_name = first_name_element.text + " " + last_name_element.text
    
    if patient_name
      new_patient = Patient.new
      new_patient.name = patient_name
      
      registration_section = RegistrationInformationC32Importer.section(clinical_document)
      imported_info = RegistrationInformationC32Importer.import_entries(registration_section)
      new_patient.registration_information ||= imported_info.first
      
      allergy_section = AllergyC32Importer.section(clinical_document)
      imported_allergies = AllergyC32Importer.import_entries(allergy_section)
      new_patient.allergies << imported_allergies
      
      #condition_section = ConditionC32Importer.section(clinical_document)
      #imported_conditions = ConditionC32Importer.import_entries(condition_section)
      #new_patient.conditions << imported_conditions
      
      new_patient.save!
    else
      false
    end
    
  end
  
end