 module RegistrationInformationC32Validation

    include MatchHelper


    #Reimplementing from MatchHelper
    def section_name
      "Person Information Module"
    end

    # Checks the contents of the REXML::Document passed in to make sure that they match the
    # information in this object. Will return an empty array if everything passes. Otherwise,
    # it will return an array of ContentErrors with a description of what's wrong.
    def validate_c32(document)
      errors = []
      begin
        patient_element = REXML::XPath.first(document, '/cda:ClinicalDocument/cda:recordTarget/cda:patientRole', {'cda' => 'urn:hl7-org:v3'})
        if patient_element
          #errors << match_value(patient_element, 'cda:id/@extension', 'person_identifier', self.person_identifier)
          name_element = REXML::XPath.first(patient_element, 
                                            "cda:patient/cda:name[cda:given='#{self.person_name.first_name}' and cda:family='#{self.person_name.last_name}']",
                                            {'cda' => 'urn:hl7-org:v3'})
          if name_element
            errors.concat(self.person_name.validate_c32(name_element))
          else
            errors << ContentError.new(:section => 'registration_information', 
                                       :subsection => 'person_name',
                                       :error_message => "Couldn't find the patient's name",
                                       :type=>'error',
                                       :location=>patient_element.xpath)
          end
          errors.concat(self.telecom.validate_c32(patient_element))
          if self.address.street_address_line_one
            address_element = REXML::XPath.first(patient_element, 
                                                 "cda:addr[cda:streetAddressLine[1]='#{self.address.street_address_line_one}']",
                                                 {'cda' => 'urn:hl7-org:v3'})
            errors.concat(self.address.validate_c32(address_element))
          end

          errors << match_value(patient_element, 'cda:patient/cda:administrativeGenderCode/@code', 'gender', self.gender.try(:code))
          errors << match_value(patient_element, 'cda:patient/cda:administrativeGenderCode/@displayName', 'gender', self.gender.try(:name))

          errors << match_value(patient_element, 'cda:patient/cda:maritalStatusCode/@code', 'marital_status', self.marital_status.try(:code))
          errors << match_value(patient_element, 'cda:patient/cda:maritalStatusCode/@displayName', 'marital_status', self.marital_status.try(:name))

          errors << match_value(patient_element, 'cda:patient/cda:religiousAffiliationCode/@code', 'religion', self.religion.try(:code))
          errors << match_value(patient_element, 'cda:patient/cda:religiousAffiliationCode/@displayName', 'religion', self.religion.try(:name))

          errors << match_value(patient_element, 'cda:patient/cda:raceCode/@code', 'race', self.race.try(:code))
          errors << match_value(patient_element, 'cda:patient/cda:raceCode/@displayName', 'race', self.race.try(:name))

          errors << match_value(patient_element, 'cda:patient/cda:ethnicGroupCode/@code', 'ethnicity', self.ethnicity.try(:code))
          errors << match_value(patient_element, 'cda:patient/cda:ethnicGroupCode/@displayName', 'ethnicity', self.ethnicity.try(:name))

          errors << match_value(patient_element, 'cda:patient/cda:birthTime/@value', 'date_of_birth', self.date_of_birth.try(:to_formatted_s, :brief))
        else
          errors << ContentError.new(:section => 'registration_information', 
                                     :error_message => 'No patientRole element found',
                                     :location => document.xpath)
        end
      rescue
        errors << ContentError.new(:section => 'registration_information', 
                                   :error_message => 'Invalid, non-parsable XML for registration data',
                                   :type=>'error',
                                   :location => document.xpath)
      end

      errors.compact

    end


  end
