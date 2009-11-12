 module PatientDataC32Validation



    def validate_c32(clinical_document)

      errors = []

      # Registration information
       errors.concat((self.registration_information.try(:validate_c32, clinical_document)).to_a)
      # Languages
        self.languages.each do |language|
          errors.concat(language.validate_c32(clinical_document))
        end

      # Healthcare Providers

        self.providers.each do |provider|
          errors.concat(provider.validate_c32(clinical_document))
        end

      # Insurance Providers

        self.insurance_providers.each do |insurance_providers|
          errors.concat(insurance_providers.validate_c32(clinical_document))
        end


      # Medications
        self.medications.each do |medication|
          errors.concat(medication.validate_c32(clinical_document))
        end

      # Supports          
        errors.concat(self.support.validate_c32(clinical_document)) if self.support

      # Allergies
        unless self.allergies.empty?
          section = AllergyC32Importer.section(clinical_document)
          if section.blank?
            errors << ContentError.new(:section => 'Allergy', :error_message => 'Unable to find Allergy section', :type=>'error')
          end
          xml_allergies = AllergyC32Importer.import_entries(section)
          self.allergies.each do |allergy|
            errors.concat(allergy.validate_c32(xml_allergies))
          end
        end

      # Conditions
        self.conditions.each_with_index do |condition, i|
          errors.concat(condition.validate_c32(clinical_document, i))
        end  

      # Information Source
     
        # Need to pass in the root element otherwise the first XPath expression doesn't work
        errors.concat(self.information_source.validate_c32(clinical_document.root))  if self.information_source

      # Advance Directive      
        errors.concat(self.advance_directive.validate_c32(clinical_document)) if self.advance_directive

      # Results
        self.results.each do |result|
          errors.concat(result.validate_c32(clinical_document))
        end

      # Immunizations
        self.immunizations.each do |immunization|
          errors.concat(immunization.validate_c32(clinical_document))
        end

      # Encounters
        self.encounters.each do |encounter|
          errors.concat(encounter.validate_c32(clinical_document))
        end

      # Removes all the nils... just in case.
      errors.compact!
      errors
    end



  end
