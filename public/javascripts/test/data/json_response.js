{
  "title": "BP Control 2",
  "numerator": 54,
  "denominator": 100,
  "id": 3,
  "numerator_fields": {
      "blood_pressures": ["120/80"]
  },
/* This is what the response/request will look like after Friday when I screw with everything */
/*  "denominator_fields": [
    "or": {
      'and': {"gender": ['Male'], "age": ["18-34"]},
      'and': {"gender": ['Female'], "age": ["35-49"]}
    }
  ],*/
  "denominator_fields": {
      "gender": ["Male", "Female"],
      "age": ["18-34", "35-49", "50-64", "65-75"],
      "diabetes": ["Yes"],
      "hypertension": ["Yes"]
  },
  
  
  "smoking": {
      "Current Smoker": [892, 900],
      "Non-Smoker": [762, 3500]
  },
  "blood_pressures": {
      "160/100": [119, 500],
      "180/110+": [96, 100],
      "120/80": [675, 2200],
      "130/80": [1060, 2000],
      "140/90": [250, 800],
      "110/75": [790, 800]
  },
  "gender": {
      "Male": [1157, 4100],
      "Female": [4554, 5901]
  },
  "age": {
      "76+": [347, 900],
      "65-75": [510, 900],
      "35-49": [1889, 2100],
      "50-64": [260, 2100],
      "18-34": [237, 3900]
  },
  "medications": {
      "Aspirin": [1721, 4300]
  },
  "diabetes": {
      "No": [7708, 9200],
      "Yes": [567, 800]
  },
  "therapies": {
      "Smoking Cessation": [1099, 1100]
  },
  "hypertension": {
      "No": [3546, 9300],
      "Yes": [680, 700]
  }
}