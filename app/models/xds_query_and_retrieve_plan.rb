class XdsQueryAndRetrievePlan < XdsPlan
  test_name "XDS Query & Retrieve"
  manual_inspection
  pending_actions 'Query Checklist' => :xds_checklist,
    'Document Checklist' => :c32_checklist
end
