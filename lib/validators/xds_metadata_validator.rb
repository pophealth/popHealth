module Validators
  class XdsMetadataValidator < Validation::BaseValidator
    def validate(expected, actual)
      errors = []
      coded_values = [:class_code, :confidentiality_code, :format_code, :healthcare_facility_type_code, :practice_setting_code, :type_code]
      coded_values.each do |cv|
        unless XdsMetadataValidator.coded_attribute_blank?(expected.send(cv))
          expected_cv = expected.send(cv)
          actual_cv = actual.send(cv)
          if XdsMetadataValidator.coded_attribute_blank?(actual_cv)
            errors << ContentError.new(:section => cv.to_s.humanize, :error_message => "Unable to find #{cv.to_s.humanize}",
                                       :validator => "XDS Metadata Validator", :inspection_type => 'XDS Provide and Register')
          else
            cvs = [:code, :display_name, :coding_scheme]
            cvs.each do |cv_attribute|
              unless expected_cv.send(cv_attribute).blank?
                expected_value = expected_cv.send(cv_attribute)
                actual_value = actual_cv.send(cv_attribute)
                unless expected_value == actual_value
                  errors << ContentError.new(:section => cv.to_s.humanize, :field_name => cv_attribute.to_s.humanize,
                                             :error_message => "Expected: #{expected_value}, Found: #{actual_value}",
                                             :validator => "XDS Metadata Validator", :inspection_type => 'XDS Provide and Register')
                end
              end
            end
          end
        end
      end
      
      unless XdsMetadataValidator.author_blank?(expected.author)
        if XdsMetadataValidator.author_blank?(actual.author)
          errors << ContentError.new(:section => 'Author', :error_message => "Unable to find Author",
                                     :validator => "XDS Metadata Validator", :inspection_type => 'XDS Provide and Register')
        else
          author_attributes = [:institution, :person, :role, :specialty]
          author_attributes.each do |aa|
            expected_value = expected.author.send(aa)
            actual_value = actual.author.send(aa)
            unless expected_value == actual_value
              errors << ContentError.new(:section => 'Author', :field_name => aa.to_s.humanize,
                                         :error_message => "Expected: #{expected_value}, Found: #{actual_value}",
                                         :validator => "XDS Metadata Validator", :inspection_type => 'XDS Provide and Register')
            end            
          end
        end
      end
      
      unless XdsMetadataValidator.source_patient_info_blank?(expected.source_patient_info)
        if XdsMetadataValidator.source_patient_info_blank?(actual.source_patient_info)
          errors << ContentError.new(:section => 'Source Patient Info', :error_message => "Unable to find Source Patient Info",
                                     :validator => "XDS Metadata Validator", :inspection_type => 'XDS Provide and Register')
        else
          source_patient_info_attributes = [:source_patient_identifier, :name, :gender, :date_of_birth, :address]
          source_patient_info_attributes.each do |spia|
            expected_value = expected.source_patient_info.send(spia).to_s
            actual_value = actual.source_patient_info.send(spia).to_s
            unless expected_value == actual_value
              errors << ContentError.new(:section => 'Source Patient Info', :field_name => spia.to_s.humanize,
                                         :error_message => "Expected: `#{expected_value}', Found: `#{actual_value}'",
                                         :validator => "XDS Metadata Validator", :inspection_type => 'XDS Provide and Register')
            end            
          end
        end
      end
      
      errors
    end
    
    def self.coded_attribute_blank?(coded_attribute)
      if coded_attribute.blank?
        return true
      else
        return coded_attribute.code.blank? && coded_attribute.display_name.blank? && coded_attribute.coding_scheme.blank?
      end
    end
    
    def self.author_blank?(author)
      if author.blank?
        return true
      else
        return author.institution.blank? && author.person.blank? && author.role.blank? && author.specialty.blank?
      end
    end
    
    def self.source_patient_info_blank?(source_patient_info)
      if source_patient_info.blank?
        return true
      else
        return source_patient_info.source_patient_identifier.blank? && source_patient_info.name.blank? &&
               source_patient_info.gender.blank? && source_patient_info.date_of_birth.blank? && 
               source_patient_info.address.blank?
      end
    end
  end
end
