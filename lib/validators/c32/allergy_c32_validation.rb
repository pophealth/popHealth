  
  module AllergyC32Validation


    include MatchHelper
    #Reimplementing from MatchHelper
    def section_name
      "Allergies Module"
    end

    def validate_c32(allergies)
      errors = []
      allergy_to_match = allergies.find {|a| self.free_text_product == a.free_text_product}
      if allergy_to_match
        results = ActiveRecordComparator.compare(self, allergy_to_match)
        errors.concat(results) if results
      else
        errors << ContentError.new(:section => 'Allergy', :error_message => "Unable to find allergy with free text product: #{self.free_text_product}")
      end
      
      errors
    end

    # Will get called by patient data if the boolean is set there
    def check_no_known_allergies_c32(clinical_document)
      errors = []
      section = REXML::XPath.first(clinical_document, "//cda:section[cda:templateId[@root = '2.16.840.1.113883.10.20.1.2']]", MatchHelper::DEFAULT_NAMESPACES)
      if section
        obs_xpath = "cda:entry/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']/cda:entryRelationship[@typeCode='SUBJ']/cda:observation[cda:templateId[@root='2.16.840.1.113883.10.20.1.18']]"
        observation = REXML::XPath.first(section, obs_xpath, MatchHelper::DEFAULT_NAMESPACES)
        if observation
          obs_value = REXML::XPath.first(observation, "cda:value", MatchHelper::DEFAULT_NAMESPACES)
          if obs_value
            errors << match_value(obs_value, "@displayName", 'no_known_allergies', 'No known allergies')
            errors << match_value(obs_value, "@code", 'no_known_allergies', '160244002')
            errors << match_value(obs_value, "@codeSystemName", 'no_known_allergies', 'SNOMED CT')
            errors << match_value(obs_value, "@codeSystem", 'no_known_allergies', '2.16.840.1.113883.6.96')
          else
            errors << ContentError.new(:section => 'allergies', :error_message => "Unable to find observation value", :location => observation.xpath)
          end
        else
          errors << ContentError.new(:section => 'allergies', :error_message => "Unable to find observation", :location => section.xpath)
        end
      else
        errors << ContentError.new(:section => 'allergies', :error_message => "Unable to find allergies section", :location => clinical_document.try(:xpath))
      end
      errors.compact
    end

  end
