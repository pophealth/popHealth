class C32DisplayAndFilePlan < TestPlan
  test_name "C32 Display and File"
  pending_actions 'XML' => :c32_xml, 'Checklist' => :c32_checklist
  manual_inspection

  module Actions
    # Display the patient C32 XML.
    def c32_xml
      redirect_to patient_path(test_plan.patient, :format => 'xml')
    end

    # Display the patient C32 checklist.
    def c32_checklist
      @patient = test_plan.patient
      render 'test_plans/c32_checklist.xml', :layout => false
    end
  end
end
