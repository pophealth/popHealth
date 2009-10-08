class ReportsController < ApplicationController

  @@reports = {
    1 => {
      :title => 'Aspirin Therapy',
      :numerator => 76,
      :denominator => 100,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['130/80']},
      :id => 1
    },
    2 => {
      :title => 'BP Control 1',
      :numerator => 61,
      :denominator => 100,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['130/80']},
      :id => 2
    },
    3 => {
      :title => 'BP Control 2',
      :numerator => 54,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['130/80']},
      :denominator => 100,
      :id => 3
    },
    4 => {
      :title => 'BP Control 3',
      :numerator => 31,
      :denominator => 100,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['130/80']},
      :id => 4
    },
    5 => {
      :title => 'Cholesterol Control 1',
      :numerator => 66,
      :denominator => 100,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['130/80']},
      :id => 5
    },
    6 => {
      :title => 'Cholesterol Control 2',
      :numerator => 75,
      :denominator => 100,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['130/80']},
      :id => 6
    },
    7 => {
      :title => 'Smoking Cessation',
      :numerator => 39,
      :denominator => 100,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['130/80']},
      :id => 7
    }
  }

  def add_random_numbers(resp = {})

    male = Gender.find_by_code('M')
    female = Gender.find_by_code('F')

    patient_count = Patient.count*1000

    #resp[:count] = 10001
    resp[:count] = patient_count.to_i

    resp[:gender] = {
      'Male' => [Patient.count_by_sql("select count(*)                                           " +
                                         "from patients, registration_information                " +
                                         "where registration_information.patient_id = patients.id " +
                                         "and registration_information.gender_id = " + male.id.to_s).to_i*1000, patient_count],
      'Female' => [Patient.count_by_sql("select count(*)                                        " +
                                        "from patients, registration_information                " +
                                        "where registration_information.patient_id = patients.id " +
                                        "and registration_information.gender_id = " + female.id.to_s).to_i*1000, patient_count]
    }
    resp[:age] = {
      "18-34" => [rand(1640), 3900],
      "35-49" => [rand(2100), 2100],
      "50-64" => [rand(2100), 2100],
      "65-75" => [rand(900), 900],
      "76+" => [rand(900), 900]
    }
    resp[:medications] = {
      "Aspirin" => [rand(4300), 4300]
    }
    resp[:therapies] = {
      "Smoking Cessation" => [rand(1100), 1100]
    }
    resp[:blood_pressures] =  {
      "110/75" => [rand(800), 800],
      "120/80" => [rand(2200), 2200],
      "130/80" => [rand(2000), 2000],
      "140/90" => [rand(800), 800],
      "160/100" => [rand(500), 500],
      "180/110+" => [rand(100), 100]
    }
    resp[:smoking] = {
      "Non-smoker" => [rand(3500), 3500],
      "Ex-smoker" => [rand(2000), 2000],
      "Smoker" => [rand(900), 900]
    }
    resp[:diabetes] = {
      "Yes" => [rand(800), 800],
      "No" => [rand(9200), 9200]
    }
    resp[:hypertension] = {
      "Yes" => [rand(700), 700],
      "No" => [rand(9300), 9300]
    }
    resp  
  end

  def handle_report_get(params)
    resp = {}
    resp = @@reports[params[:id].to_i]
    add_random_numbers(resp)
    resp.to_json
  end

  # GET /reports
  def index
    if params[:id]
      handle_report_get(params)
      render :json => handle_report_get(params)
    else
      resp = {
        "populationCount" => 10001,
        "populationName" => "Lahey (34234)",
        "reports" => []
      }
      @@reports.values.each {|report|
        resp['reports'] << report
      }
      render :json => resp.to_json
    end
  end

  # GET /reports/1
  def show
    render :json => handle_report_get(params)
  end

end
