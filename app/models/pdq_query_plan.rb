class PdqQueryPlan < PixPdqPlan
  test_name 'PDQ Query'
  pending_actions 'Inspect' => :pix_pdq_inspect
  completed_actions 'Inspect' => :pix_pdq_inspect
end
