class PixPdqPlan < TestPlan
  module Actions
    # Display the PIX/PDQ results inspection page.
    def pix_pdq_inspect
      @patient = @test_plan.patient
    end
  end
end
