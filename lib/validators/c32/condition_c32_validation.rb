   module ConditionC32Validation

      include MatchHelper




      #Reimplementing from MatchHelper
      def section_name
        "Conditions Module"
      end

      def validate_c32(document, index = 0)
        errors = []
        begin
          section = REXML::XPath.first(document,"//cda:section[cda:templateId/@root='2.16.840.1.113883.10.20.1.11']",MatchHelper::DEFAULT_NAMESPACES)
          act = REXML::XPath.match(section,"cda:entry/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']",MatchHelper::DEFAULT_NAMESPACES)[index]
          observation = REXML::XPath.first(act,"cda:entryRelationship[@typeCode='SUBJ']/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.28']",MatchHelper::DEFAULT_NAMESPACES)
          code = REXML::XPath.first(observation,"cda:code[@codeSystem='2.16.840.1.113883.6.96']",MatchHelper::DEFAULT_NAMESPACES)
          if problem_type
            errors.concat problem_type.validate_c32(code)
          end
          errors << match_value(observation, "cda:effectiveTime/cda:low/@value", "start_event", start_event.try(:to_formatted_s, :brief))
          errors << match_value(observation, "cda:effectiveTime/cda:high/@value", "end_event", end_event.try(:to_formatted_s, :brief))
          if free_text_name
            text =  REXML::XPath.first(observation,"cda:text",MatchHelper::DEFAULT_NAMESPACES)
            deref_text = deref(text)
            if(deref_text != free_text_name)
              errors << ContentError.new(:section => "Condition",
                                         :error_message => "Free text name #{free_text_name} does not match #{deref_text}",
                                         :location => (text)? text.xpath : (code)? code.xpath : section.xpath)
            end
            # if the free text name matches a code from the SNOMED problem list, perform a coded value inspection
            snowmed_problem = SnowmedProblem.find(:first, :conditions => {:name => free_text_name})
            if snowmed_problem
              code =  REXML::XPath.first(observation,"cda:value",MatchHelper::DEFAULT_NAMESPACES)
              errors << match_value(observation, 
                                    "cda:value[@codeSystem='2.16.840.1.113883.6.96']/@code", 
                                    'condition_code', 
                                    snowmed_problem.code)
            end
          end
        rescue
          errors << ContentError.new(:section => 'Condition',
                                     :error_message => 'Invalid, non-parsable XML for condition data',
                                     :type => 'error',
                                     :location => document.xpath)
        end
        errors.compact
      end


    end
