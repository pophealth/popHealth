// We"ll definitely want JSON back...and this needs to be the full data
// I don"t want to do a data merge, I"m just going to pop out the old
// object and pop in this one, then call a refresh() method to build
// the UI and recalculate the percentages.

{
  "title": "Some sort of report",
  "dataUrl": "/reports/4",
  "count": 10001,
  "numerator": 0,
  "denominator": 4100,
  "numerator_fields": {},
  "denominator_fields": {"gender": ["Male"]}, // These fields should match up letter-for-letter with the actual field names
  "gender": {                             // All are human-readable (since they"re strings it doesn"t matter, and is easier to keep track of)
    "Male": [4100, 4100],               // Each item should be a two element array...[currently selected, high-water mark]
    "Female": [0, 5901]                 // Since only males are selected, 0 females are currently selected (out of 5901)
  },
  "age": {
    "18-34": [1640, 3900],
    "35-49": [861, 2100],
    "50-64": [902, 2100],
    "65-75": [410, 900],
    "76+": [33, 900]
  },
  "medications": {
    "Aspirin": [1763, 4300]
  },
  "therapies": {
    "Smoking Cessation": [50, 1100]
  },
  "blood_pressures": {
    "110/75": [328, 800],
    "120/80": [902, 2200],
    "130/80": [820, 2000],
    "140/90": [328, 800],
    "160/100": [205, 500],
    "180/110+": [41, 100]
  },
  "smoking": {
    "Non-smoker": [1230, 3500],
    "Ex-smoker": [902, 2000],
    "Smoker": [50, 900]
  },
  "diabetes": {
    "Yes": [326, 800],
    "No": [3772, 9200]
  },
  "hypertension": {
    "Yes": [287, 700],
    "No": [3813, 9300]
  }
}