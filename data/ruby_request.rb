# Technically this should be a GET request with a params string but that might get unwieldy...the other option
# is a POST with a JSON object...we'll see I guess

# Fields with nothing selected won't be sent...no point in crowding the request. You can always do a merge
# on the server.

params = {
  :denominator => {
    :gender => ['Male', 'Female'],
    :ages => ['18-34', '35-49', '50-64', '65-75', '76+'], # If these ranges change we may want to rethink this
    :medications => ['Aspirin', '...'],
    :therapies => ['Smoking Cessation', '...'],
    :blood_pressures => ['110/75', '120/80', '...'],
    :smoking => ['Non-smoker', 'Ex-smoker', 'Smoker'],
    :diabetes => ['Yes', 'No'], # This can't be boolean because it could be neither, one, or both
    :hypertension => ['Yes', 'No'] # Same
  },
  :numerator => {
    :gender => ['Male', 'Female'],
    :ages => ['18-34', '35-49', '50-64', '65-75', '76+'], # If these ranges change we may want to rethink this
    :medications => ['Aspirin', '...'],
    :therapies => ['Smoking Cessation', '...'],
    :blood_pressures => ['110/75', '120/80'],
    :smoking => ['Non-smoker', 'Ex-smoker', 'Smoker'],
    :diabetes => ['Yes', 'No'], # This can't be boolean because it could be neither, one, or both
    :hypertension => ['Yes', 'No'] # Same
  },
  :report_name => "Aspirin Therapy",
  :report_id => 12 # Maybe?? Do you guys persist these reports? If so they need an ID
}