class PixQueryPlan < PixPdqPlan
  test_name 'PIX Query'
  pending_actions 'Inspect' => :pix_pdq_inspect
  completed_actions 'Inspect' => :pix_pdq_inspect
end
