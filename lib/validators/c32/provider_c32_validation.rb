module ProviderC32Validation

  include MatchHelper


  #Reimplementing from MatchHelper
  def section_name
    "Healthcare Providers Module"
  end

  def validate_c32(document)
    errors = []
    begin
      namespaces = {'cda'=>"urn:hl7-org:v3",'sdtc'=>"urn:hl7-org:sdtc"}
      provider = REXML::XPath.first(document,'/cda:ClinicalDocument/cda:documentationOf/cda:serviceEvent/cda:performer',namespaces)
      unless provider
        return [ContentError.new(:section => 'Provider', 
                                 :error_message => "Provider not found", 
                                 :location => document.try(:xpath))]    
      end     
      date_range = REXML::XPath.first(provider, 'cda:time',namespaces)
      assigned = REXML::XPath.first(provider,'cda:assignedEntity',namespaces)
      if assigned
        if provider_role
          errors.concat  provider_role.validate_c32(REXML::XPath.first(provider,'cda:functionCode',namespaces))
        end
        if provider_type
          errors.concat provider_type.validate_c32(REXML::XPath.first(assigned,'cda:code',namespaces))
        end
        if person_name
           errors.concat  person_name.validate_c32(REXML::XPath.first(assigned,'cda:assignedPerson/cda:name',namespaces))
        end 
        if address
          errors.concat address.validate_c32(REXML::XPath.first(assigned,'cda:addr',namespaces))
        end
        if telecom
          errors.concat telecom.validate_c32(assigned)
        end
   
        if patient_identifier
          id = REXML::XPath.first(assigned,'sdtc:patient/sdtc:id',namespaces)
          if id
            errors << match_value(id,'@root','id',patient_identifier)
          else
            errors << ContentError.new(:section => section,
                                       :error_message => "Expected to find a patient identifier with the value of #{patient_identifier}",
                                       :location => assigned.xpath)
          end
        end         
      else
        errors << ContentError.new(:section=>section,
                                   :error_message=>"Assigned person not found",
                                   :location=>(document) ? document.xpath : nil)
      end
    rescue
      puts $!
      errors << ContentError.new(:section => 'HealthCare Provider', 
                                 :error_message => 'Invalid, non-parsable XML for HealthCare Provider data',
                                 :type=>'error',
                                 :location => document.xpath)
    end
    errors.compact
  end


end
