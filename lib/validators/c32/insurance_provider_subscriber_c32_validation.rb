 module InsuranceProviderSubscriberC32Validation


    include MatchHelper



    def validate_c32(act)

      unless act
        return [ContentError.new]
      end

      errors = []

      begin
        particpantRole = REXML::XPath.first(act,"cda:participant[@typeCode='HLD']/cda:participantRole[@classCode='IND']",MatchHelper::DEFAULT_NAMESPACES)
        if person_name
          errors.concat person_name.validate_c32(REXML::XPath.first(particpantRole,"cda:playingEntity/cda:name",MatchHelper::DEFAULT_NAMESPACES))
        end       
        if address
          errors.concat address.validate_c32(REXML::XPath.first(particpantRole,'cda:addr',MatchHelper::DEFAULT_NAMESPACES))
        end
        if telecom
          errors.concat telecom.validate_c32(REXML::XPath.first(particpantRole,'cda:telecom',MatchHelper::DEFAULT_NAMESPACES))
        end
      rescue
        errors << ContentError.new(
                :section => 'Subscriber Information', 
                :error_message => 'Failed checking name, address and telecom details on the insurance provider subcriber XML',
                :type=>'error',
                :location => act.xpath)
      end

      return errors.compact
    end



  end
  