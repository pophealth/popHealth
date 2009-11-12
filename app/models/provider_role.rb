class ProviderRole < ActiveRecord::Base
  extend RandomFinder
  has_select_options

   

   def to_c32(xml, free_text=nil)
    xml.functionCode("code" => code,
                     "displayName" => name,
                     "codeSystem" => "2.16.840.1.113883.12.443", 
                     "codeSystemName" => "Provider Role") do
      unless free_text.blank?
        xml.originalText free_text
      end
    end
  end

end
