 
  module AdvanceDirectiveC32Validation

    include MatchHelper



    def validate_c32(document)

      errors = []

      begin
        section = REXML::XPath.first(document,"//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.1.1']",MatchHelper::DEFAULT_NAMESPACES)
        if section
          observation = REXML::XPath.first(section,"cda:entry/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.17']",MatchHelper::DEFAULT_NAMESPACES)
          # match person type info
          entity = REXML::XPath.first(observation,"cda:participant[@typeCode='CST']/cda:participantRole[@classCode='AGNT']",MatchHelper::DEFAULT_NAMESPACES)
          code = REXML::XPath.first(observation,"cda:code",MatchHelper::DEFAULT_NAMESPACES)
          text =  REXML::XPath.first(code,"cda:originalText",MatchHelper::DEFAULT_NAMESPACES)
          deref_text = deref(text)

          if advance_directive_type
            errors.concat advance_directive_type.validate_c32(code)
          end

          if(deref_text != free_text)
            errors << ContentError.new(:section=>"Advance Directive",
                                       :error_message=>"Directive text #{free_text} does not match #{deref_text}",
                                       :location=>(text)? text.xpath : (code)? code.xpath : section.xpath )
          end
          if person_name
            errors.concat person_name.validate_c32(REXML::XPath.first(entity,'cda:playingEntity/cda:name',MatchHelper::DEFAULT_NAMESPACES))
          end
          if address
            errors.concat address.validate_c32(REXML::XPath.first(entity,'cda:addr',MatchHelper::DEFAULT_NAMESPACES))
          end
          if telecom
            errors.concat telecom.validate_c32(entity)
          end
        else
            errors << ContentError.new(:section => 'Advance Directive', 
                                      :error_message => 'Advance Directive not found in document',
                                      :type=>'error',
                                      :location => document.xpath)          
        end
      rescue
        errors << ContentError.new(:section => 'Advance Directive', 
                                   :error_message => 'Invalid, non-parsable XML for advance directive data',
                                   :type=>'error',
                                   :location => document.xpath)
      end

      errors.compact
      

    end



  end
