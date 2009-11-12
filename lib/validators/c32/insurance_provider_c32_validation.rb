  module InsuranceProviderC32Validation

    include MatchHelper

   


    #Reimplementing from MatchHelper
    def section_name
      "Insurance Providers Module"
    end

    def validate_c32(document)
      errors = []

      begin
        section = REXML::XPath.first(document,"//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.1.9']",MatchHelper::DEFAULT_NAMESPACES)
        parentAct = REXML::XPath.first(section,"cda:entry/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.20']",MatchHelper::DEFAULT_NAMESPACES)
        childAct = REXML::XPath.first(parentAct,"cda:entryRelationship/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.26']",MatchHelper::DEFAULT_NAMESPACES)

        if group_number
          errors << match_value(childAct, "cda:id/@root", "group_number", self.group_number.to_s)
        end

        if insurance_type 
          code = REXML::XPath.first(childAct,"cda:code[@codeSystem='2.16.840.1.113883.6.255.1336']",MatchHelper::DEFAULT_NAMESPACES)
          errors.concat insurance_type.validate_c32(code)
        end

        if represented_organization 
          representedOrganization = REXML::XPath.first(childAct,
            "cda:performer[@typeCode='PRF']/cda:assignedEntity[@classCode='ASSIGNED']/cda:representedOrganization[@classCode='ORG']",MatchHelper::DEFAULT_NAMESPACES)
          errors << match_value(representedOrganization, "cda:name", "represented_organization_name", self.represented_organization.to_s)
        end

        if self.insurance_provider_guarantor && !insurance_provider_guarantor.person_blank?

          # insurance provider's represented organization test
          if represented_organization
            begin   
              errors << match_value(childAct, "cda:performer/@typeCode", "PRF", "PRF")
            rescue
              errors << ContentError.new(
                :section => 'Insurance Provider', 
                :error_message => 'Failed checking that the XML element''performer'' has attribute ''typeCode'' that is equal to ''PRF''',
                :type=>'error',
                :location => childAct.xpath)
            end
          end

          # TODO start insurance provider's effective date test
          # end insurance provider's effective date test

          # insurance provider guarantor
          if insurance_provider_guarantor.person_name.first_name && insurance_provider_guarantor.person_name.last_name
            guarantor_name_element = REXML::XPath.first(childAct, 
              "cda:performer/cda:assignedEntity/cda:assignedPerson/cda:name[cda:given='#{self.insurance_provider_guarantor.person_name.first_name}' and cda:family='#{self.insurance_provider_guarantor.person_name.last_name}']",
              {'cda' => 'urn:hl7-org:v3'})
            if guarantor_name_element
              errors.concat(self.insurance_provider_guarantor.person_name.validate_c32(guarantor_name_element))
            else
              errors << ContentError.new(:section => 'insurance_provider', 
                                         :subsection => 'guarantor_name',
                                         :error_message => "Couldn't match the insurance provider guarantor's name",
                                         :type => 'error',
                                         :location => guarantor_name_element.xpath)
            end
          end

          # insurance provider subscriber
          #if insurance_provider_subscriber
          #  self.insurance_provider_subscriber.validate_c32(childAct)
          #end

        end

      rescue
        errors << ContentError.new(:section => 'Insurance Provider', 
                                   :error_message => 'Invalid, non-parsable XML for Insurance Provider data',
                                   :type=>'error',
                                   :location => document.xpath)
      end
      errors.compact
    end

  end
