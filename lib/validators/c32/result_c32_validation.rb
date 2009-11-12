    module ResultC32Validation

      include MatchHelper

      def section_template_id
        '2.16.840.1.113883.10.20.1.14'
      end

      def statement_ccd_template_id
        '2.16.840.1.113883.10.20.1.31'
      end

      def statement_c32_template_id
        '2.16.840.1.113883.3.88.11.32.16'
      end

      #Reimplementing from MatchHelper
      def section_name
        "Results Module"
      end

      def validate_c32(document)

        errors = []

        # Another nit-noid of the CCD specification... if there is an organizer of a lab result, and that 
        # organizaer has an id, result type and a status code, the XML is changed for the reults and is 
        # wrapped within an organizer/component XML element.
        #
        # Otherwise, that XPath is not included in the XML and the result is simply an observation...  This
        # is specified in the CCD documentation and NOT the C32 specification... so this really complicates
        # things for folks who only have access to the C32 spec.
        if organizer_id && result_type_code && act_status_code
          # TODO Organizer XPath Expressions
        else
          errors << safe_match(document) do 
            errors << match_required(document,
                                     "//cda:section[./cda:templateId[@root = '#{section_template_id}']]",
                                     MatchHelper::DEFAULT_NAMESPACES,
                                     {},
                                     nil,
                                     "C32 Result section with templateId #{section_template_id} not found",
                                     document.xpath) do |section|
              errors << match_required(section,
                                     "./cda:entry/cda:observation[cda:id/@root = $id]",
                                    MatchHelper::DEFAULT_NAMESPACES,
                                    {"id" => self.result_id},
                                    nil,
                                    "Result with #{self.result_id} not found",
                                    section.xpath) do |result_element|
                errors << match_required(result_element,
                                        "./cda:code",
                                        MatchHelper::DEFAULT_NAMESPACES,
                                        {},
                                        nil,
                                        "Required code element not found",
                                        result_element.xpath) do |code_element|
                  errors << match_value(code_element, "@code", "result_code", self.result_code)
                  errors << match_value(code_element, "@displayName", "result_code_display_name", self.result_code_display_name)
                  errors << match_value(code_element, "@codeSystem", "code_system", self.code_system.try(:code))
                  errors << match_value(code_element, "@codeSystemName", "code_system_name", self.code_system.try(:name))
                end
                errors << match_value(result_element, "cda:statusCode/@code", "status_code", self.status_code)
                errors << match_value(result_element, "cda:effectiveTime/@value", "result_date", self.result_date.try(:to_formatted_s, :brief))
                errors << match_value(result_element, "cda:value/@value", "value_scalar", self.value_scalar)
                errors << match_value(result_element, "cda:value/@unit", "value_unit", self.value_unit)
              end
            end
          end
        end

        errors.compact

      end

    end
