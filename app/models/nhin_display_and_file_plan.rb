class NhinDisplayAndFilePlan < TestPlan
  test_name "NHIN Display and File"
  pending_actions 'XML' => :nhin_xml, 'Checklist' => :nhin_checklist
  manual_inspection

  module Actions
    def nhin_xml
      redirect_to patient_path(test_plan.patient, :format => 'xml')
    end

    def nhin_checklist
      @patient = test_plan.patient
      render 'test_plans/nhin_checklist.xml', :layout => false
    end
  end
end