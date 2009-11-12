class XdsProvideAndRegisterPlan < XdsPlan
  test_name 'XDS Provide & Register'
  pending_actions 'Checklist' => :xds_checklist, 'Execute' => :xds_select_document
  completed_actions 'Inspect' => :xds_inspect

  # Validate provided XDS metadata. This is the primary validation step for
  # XDS P&R tests.
  #
  # @param [XDS::Metadata] metadata_of_interest
  def validate_xds_metadata metadata_of_interest
    if metadata_of_interest
      validator = Validators::XdsMetadataValidator.new
      validation_errors = validator.validate test_type_data, metadata_of_interest
      if validation_errors.empty?
        content_errors.clear
        pass
      else
        self.content_errors = validation_errors
        fail
      end
      cdoc = ClinicalDocument.new \
        :uploaded_data => XDSUtils.retrieve_document(metadata_of_interest)
      update_attributes :clinical_document => cdoc
    else
      content_errors << ContentError.new(
        :error_message => "Unable to find metadata in the XDS Registry",
        :validator => "XDS Metadata Validator",
        :inspection_type => 'XDS Provide and Register')
      fail
    end
  end

  # Once a plan has been completed, this method returns the list
  # of validators used to get the results.
  #
  # @return [Array<String>] validators
  def validators
    content_errors.map(&:validator).uniq if not pending?
  end

  module Actions
    # Display all XDS metadata for the patient attached to this test plan.
    def xds_select_document
      @metadata = test_plan.fetch_xds_metadata test_plan.patient.patient_identifier
    end

    # Compare selected XDS metadata to the test plan metadata.
    def xds_compare
      metadata = YAML.load(params[:test_type_data])
      test_plan.validate_xds_metadata metadata
      render 'test_plans/xds_inspect'
    end

    # Display the XDS results inspection page.
    def xds_inspect
    end
  end
end
