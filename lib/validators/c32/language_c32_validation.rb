
module LanguageC32Validation


  include MatchHelper



  #Reimplementing from MatchHelper
  def section_name
    "Languages Module"
  end

  def validate_c32(document)
    errors = []
    begin
      language_communication_element = REXML::XPath.first(document, "//cda:recordTarget/cda:patientRole/cda:patient/cda:languageCommunication[cda:languageCode/@code='#{language_code}']", MatchHelper::DEFAULT_NAMESPACES)
      if language_communication_element
        if language_ability_mode
          errors << match_value(language_communication_element, 
                                "cda:modeCode/@code", 
                                "language_ability_mode", 
                                self.language_ability_mode.code)
        end
        if preference
          errors << match_value(language_communication_element, 
                                "cda:preferenceInd/@value", 
                                "preference", 
                                self.preference.to_s)        
        end
      else
        errors << ContentError.new(:section => 'languages', 
                                   :error_message => "No language found for #{language_code}",
                                   :location=>document.xpath)
      end
    rescue
      errors << ContentError.new(:section => 'languages', 
                                 :error_message => 'Invalid, non-parsable XML for language data',
                                 :type=>'error',
                                 :location => document.xpath)
    end
    errors.compact
  end


end