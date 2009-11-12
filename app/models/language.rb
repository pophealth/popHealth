class Language < ActiveRecord::Base

  belongs_to :iso_country
  belongs_to :iso_language
  belongs_to :language_ability_mode

  include PatientChild

  def requirements
    {
      :iso_language_id => :required,
      :iso_country_id => :required,
      :preference => :required,
    }
  end

  

  # Creates the language code as specified in Section 2.2 of the CCD Spec
  def language_code
    if self.iso_country
      "#{self.iso_language.code}-#{self.iso_country.code}"
    else
      self.iso_language.code      
    end
  end

  def to_c32(xml)
    xml.languageCommunication {
      xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.2")
      if iso_language && iso_country  
        xml.languageCode("code" => iso_language.code + "-" + iso_country.code)
      end 
      if language_ability_mode   
        xml.modeCode("code" => language_ability_mode.code, 
                     "displayName" =>  language_ability_mode.name,
                     "codeSystem" => "2.16.840.1.113883.5.60",
                     "codeSystemName" => "LanguageAbilityMode")
      end
      if preference != nil
        xml.preferenceInd("value" => preference)
      end
    }  
  end

  def randomize()
    self.iso_country = IsoCountry.find :random
    self.iso_language = IsoLanguage.find :random
    self.language_ability_mode = LanguageAbilityMode.find :random
    self.preference = false
  end

end
