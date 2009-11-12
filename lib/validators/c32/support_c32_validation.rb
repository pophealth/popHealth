
module SupportC32Validation
  include MatchHelper

  #Reimplementing from MatchHelper
  def section_name
    "Supports Module"
  end

  def validate_c32(document)
    errors = []
    begin
      support = REXML::XPath.first(document, "/cda:ClinicalDocument/cda:participant/cda:associatedEntity[cda:associatedPerson/cda:name/cda:given/text() = $first_name ] | /cda:ClinicalDocument/cda:recordTarget/cda:patientRole/cda:patient/cda:guardian[cda:guardianPerson/cda:name/cda:given/text() = $first_name]",
         {'cda' => 'urn:hl7-org:v3'}, {"first_name" => person_name.first_name})
      if support
        time_element = REXML::XPath.first(support, "../cda:time", {'cda' => 'urn:hl7-org:v3'})
        if time_element
          if self.start_support
            errors << match_value(time_element, "cda:low/@value", "start_support", self.start_support.to_formatted_s(:brief))
          end
          if self.end_support
            errors << match_value(time_element, "cda:high/@value", "end_support", self.end_support.to_formatted_s(:brief))
          end
        else
          errors <<  ContentError.new(:section => "Support", 
                                      :subsection => "date",
                                      :error_message => "No time element found in the support",
                                      :location => support.xpath)
        end
        if self.address
          add =  REXML::XPath.first(support,"cda:addr",{'cda' => 'urn:hl7-org:v3'})
          if add
             errors.concat   self.address.validate_c32(add)  
          else                                 
             errors <<  ContentError.new(:section => "Support", 
                                         :subsection => "address",
                                         :error_message => "Address not found in the support section #{support.xpath}",
                                         :location => support.xpath)          
          end
        end
        if self.telecom
          errors.concat self.telecom.validate_c32(support)
        end
        # classcode
        errors << match_value(support, "@classCode", "contact_type", contact_type.try(:code))
        errors << match_value(support, "cda:code[@codeSystem='2.16.840.1.113883.5.111']/@code", "relationship", relationship.try(:code))
      else
        # add the error for no support object being there 
        errors <<  ContentError.new(:section=> "Support", 
                                    :error_message=> "Support element does not exist")          
      end
    rescue
      errors << ContentError.new(:section => 'Support', 
                                 :error_message => 'Invalid, non-parsable XML for supports data',
                                 :type=>'error',
                                 :location => document.xpath)
    end
    errors.compact
  end



end
