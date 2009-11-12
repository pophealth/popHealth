class PixFeedPlan < PixPdqPlan
  test_name 'PIX Feed'
  pending_actions 'Compare>' => :pix_feed_setup
  completed_actions 'Inspect' => :pix_pdq_inspect

  serialize :test_type_data, Hash

  # Get the expected PatientIdentifier value.
  #
  # @return [PatientIdentifier]
  def expected
    PatientIdentifier.new(test_type_data || {})
  end

  # Set the expected PatientIdentifier value.
  #
  # @param [PatientIdentifier] patient_identifier
  def expected= patient_identifier
    self.test_type_data = patient_identifier.attributes
  end

  # Compare the provided patient identifier to the expected value.
  # This is the primary test used to determine pass/fail state.
  #
  # @param [PatientIdentifier] pi value for comparison.
  # @return [true|false] true if pi matches expected, false otherwise.
  def matches_expected? pi
    pi.patient_identifier == expected.patient_identifier &&
      pi.affinity_domain == expected.affinity_domain
  end

  module Actions
    # Display the PIX Feed setup page (collects expected values).
    def pix_feed_setup
      render :layout => false
    end

    # Run the test plan. This marks the test as passed or failed.
    def pix_feed_compare
      test_plan.expected = PatientIdentifier.new params[:patient_identifier]

      test_plan.patient.patient_identifiers.each do |pi|
        if test_plan.matches_expected? pi
          test_plan.pass
          break
        end
      end

      unless test_plan.passed?
        test_plan.fail
      end

      redirect_to test_plans_url
    end
  end

end
