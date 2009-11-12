class GenerateAndFormatPlan < TestPlan
  test_name "Generate and Format"
  pending_actions 'Execute>' => :doc_upload
  completed_actions 'Inspect' => :doc_inspect, 'Checklist' => :doc_checklist
  serialize :test_type_data, Hash

  class ValidationError < StandardError; end

  def initialize *args
    super
    self.test_type_data ||= {}
  end

  # @return true if UMLS is enabled for this test, false otherwise.
  def umls_enabled?
    !!test_type_data[:umls_enabled]
  end

  # Used by validate_clinical_document_content to indicate whether UMLS
  # was used. You can check for this flag by calling umls_enabled?
  def umls_enabled= flag
    test_type_data[:umls_enabled] = flag
  end

  # This is the primary validation operation for Generate and Format.
  def validate_clinical_document_content
    document = clinical_document.as_xml_document
    validator = Validation.get_validator(clinical_document.doc_type)

    logger.debug(validator.inspect)
    errors = nil
    begin
      errors = validator.validate(patient, document)
    rescue Exception => e # XXX rescuing everything is almost never a good idea
      logger.info("ERROR DURING VALIDATION: #{e}")
      raise ValidationError
    end
    logger.debug(errors.inspect)
    logger.debug("PD #{patient}  doc #{document}")

    content_errors.clear
    content_errors.concat errors

    if validator.contains_kind_of?(Validators::Umls::UmlsValidator)
      self.umls_enabled = true
    end

    if content_errors.empty?
      pass
    else
      fail
    end

    content_errors
  end

  module Actions
    def doc_upload
      render 'test_plans/doc_upload', :layout => !request.xhr?
    end

    def doc_validate
      test_plan.update_attributes! :clinical_document =>
        ClinicalDocument.create!(params[:clinical_document])
      begin
        test_plan.validate_clinical_document_content
      rescue ValidationError
        flash[:notice] = "An error occurred while validating the document"
      end
      redirect_to test_plans_url
    end
    
    def doc_checklist
      @patient = test_plan.patient
      render 'test_plans/doc_checklist.xml', :layout => false
    end
    
    def doc_inspect
    end
    
  end

end

