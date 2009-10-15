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

  def load_static_content
    @patient_count = Patient.count_by_sql("select count(*) from patients").to_i
    @male = Gender.find_by_code('M')
    @female = Gender.find_by_code('F')
  end

  def load_report_data(resp = {})

    resp[:count] = @patient_count.to_i

    resp[:gender] = {
      'Male' => [Patient.count_by_sql("select count(*)                                         " +
                                      "from patients, registration_information                 " +
                                      "where registration_information.patient_id = patients.id " +
                                      "and registration_information.gender_id = " + @male.id.to_s).to_i, @patient_count],
      'Female' => [Patient.count_by_sql("select count(*)                                         " +
                                        "from patients, registration_information                 " +
                                        "where registration_information.patient_id = patients.id " +
                                        "and registration_information.gender_id = " + @female.id.to_s).to_i, @patient_count]
    }

    resp[:age] = {
      "18-34" => [Patient.count_by_sql("select count(*)                                         " +
                                       "from patients, registration_information                 " +
                                       "where registration_information.patient_id = patients.id " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE >= (365*18) " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE < (365*35)"), @patient_count],
      "35-49" => [Patient.count_by_sql("select count(*)                                         " +
                                       "from patients, registration_information                 " +
                                       "where registration_information.patient_id = patients.id " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE >= (365*34) " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE < (365*50)"), @patient_count],
      "50-64" => [Patient.count_by_sql("select count(*)                                         " +
                                       "from patients, registration_information                 " +
                                       "where registration_information.patient_id = patients.id " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE >= (365*50) " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE < (365*65)"), @patient_count],
      "65-75" => [Patient.count_by_sql("select count(*)                                         " +
                                       "from patients, registration_information                 " +
                                       "where registration_information.patient_id = patients.id " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE >= (365*65) " +
                                       "and now()::DATE - registration_information.date_of_birth::DATE < (365*76)"), @patient_count],
      "76+" => [Patient.count_by_sql("select count(*)                                         " +
                                     "from patients, registration_information                 " +
                                     "where registration_information.patient_id = patients.id " +
                                     "and now()::DATE - registration_information.date_of_birth::DATE >= (365*76)"), @patient_count]
    }

    resp[:medications] = {
      "Aspirin" => [Patient.count_by_sql("select count(*)                             " +
                                         "from patients, medications                  " +
                                         "where medications.patient_id = patients.id  " +
                                         "and medications.product_code = 'R16CO5Y76E'"), @patient_count]
    }

    resp[:therapies] = {
      "Smoking Cessation" => [rand(1100), 1100]
    }

    resp[:blood_pressures] =  {
      #range for 110/75 is 100-119/70-79
      "110/75" => [Patient.count_by_sql("select count(*)                                                                " +
                                        "from patients, abstract_results systolic, abstract_results diastolic           " +
                                        "where systolic.patient_id = patients.id and diastolic.patient_id = patients.id " +
                                        "and systolic.result_code = '8480-6' " + 
                                        "and systolic.value_scalar::varchar::text::int >= 100 " + 
                                        "and systolic.value_scalar::varchar::text::int <= 119 " +
                                        "and diastolic.result_code = '8462-4' " + 
                                        "and diastolic.value_scalar::varchar::text::int >= 70 " +
                                        "and diastolic.value_scalar::varchar::text::int <= 79"), @patient_count],

      #range for 120/80 is 110-129/75-84
      "120/80" => [Patient.count_by_sql("select count(*)                                                                " +
                                        "from patients, abstract_results systolic, abstract_results diastolic           " +
                                        "where systolic.patient_id = patients.id and diastolic.patient_id = patients.id " +
                                        "and systolic.result_code = '8480-6' " + 
                                        "and systolic.value_scalar::varchar::text::int >= 110 " + 
                                        "and systolic.value_scalar::varchar::text::int <= 129 " +
                                        "and diastolic.result_code = '8462-4' " + 
                                        "and diastolic.value_scalar::varchar::text::int >= 75 " +
                                        "and diastolic.value_scalar::varchar::text::int <= 84"), @patient_count],

      #range for 130/80 is 120-139/75-84
      "130/80" => [Patient.count_by_sql("select count(*)                                                                " +
                                        "from patients, abstract_results systolic, abstract_results diastolic           " +
                                        "where systolic.patient_id = patients.id and diastolic.patient_id = patients.id " +
                                        "and systolic.result_code = '8480-6' " + 
                                        "and systolic.value_scalar::varchar::text::int >= 120 " + 
                                        "and systolic.value_scalar::varchar::text::int <= 139 " +
                                        "and diastolic.result_code = '8462-4' " + 
                                        "and diastolic.value_scalar::varchar::text::int >= 75 " +
                                        "and diastolic.value_scalar::varchar::text::int <= 84"), @patient_count],

      #range for 140/90 is 130-149/85-94
      "140/90" => [Patient.count_by_sql("select count(*)                                                                " +
                                        "from patients, abstract_results systolic, abstract_results diastolic           " +
                                        "where systolic.patient_id = patients.id and diastolic.patient_id = patients.id " +
                                        "and systolic.result_code = '8480-6' " + 
                                        "and systolic.value_scalar::varchar::text::int >= 130 " + 
                                        "and systolic.value_scalar::varchar::text::int <= 149 " +
                                        "and diastolic.result_code = '8462-4' " + 
                                        "and diastolic.value_scalar::varchar::text::int >= 85 " +
                                        "and diastolic.value_scalar::varchar::text::int <= 94"), @patient_count],
      #range for 160/100 is 150-169/95-104
      "160/100" => [Patient.count_by_sql("select count(*)                                                                " +
                                         "from patients, abstract_results systolic, abstract_results diastolic           " +
                                         "where systolic.patient_id = patients.id and diastolic.patient_id = patients.id " +
                                         "and systolic.result_code = '8480-6' " + 
                                         "and systolic.value_scalar::varchar::text::int >= 150 " + 
                                         "and systolic.value_scalar::varchar::text::int <= 169 " +
                                         "and diastolic.result_code = '8462-4' " + 
                                         "and diastolic.value_scalar::varchar::text::int >= 95 " +
                                         "and diastolic.value_scalar::varchar::text::int <= 104"), @patient_count],
      #range for 180/110+ is 170-189/105-114
      "180/110+" => [Patient.count_by_sql("select count(*)                                                               " +
                                         "from patients, abstract_results systolic, abstract_results diastolic           " +
                                         "where systolic.patient_id = patients.id and diastolic.patient_id = patients.id " +
                                         "and systolic.result_code = '8480-6' " + 
                                         "and systolic.value_scalar::varchar::text::int >= 170 " + 
                                         "and systolic.value_scalar::varchar::text::int <= 189 " +
                                         "and diastolic.result_code = '8462-4' " + 
                                         "and diastolic.value_scalar::varchar::text::int >= 105 " +
                                         "and diastolic.value_scalar::varchar::text::int <= 114"), @patient_count]
    }

    resp[:smoking] = {
      "Non-smoker" => [rand(3500), 3500],
      "Ex-smoker" => [rand(2000), 2000],
      "Smoker" => [rand(900), 900]
    }

    # diabetes
    entire_diabetics_population = Patient.count_by_sql("select count(*) from patients")
    diabetics = Patient.count_by_sql("select count(*)                           " +
                                     "from patients, conditions                 " +
                                     "where conditions.patient_id = patients.id " +
                                     "and conditions.free_text_name = 'Diabetes mellitus disorder'")
    resp[:diabetes] = {
      "Yes" => [diabetics, @patient_count],
      "No" => [(entire_diabetics_population-diabetics), @patient_count],
    }

    # hypertension
    entire_hypertension_population = Patient.count_by_sql("select count(*) from patients")
    hypertension = Patient.count_by_sql("select count(*)                           " +
                                        "from patients, conditions                 " +
                                        "where conditions.patient_id = patients.id " +
                                        "and conditions.free_text_name = 'Essential hypertension disorder'")
    resp[:hypertension] = {
      "Yes" => [hypertension, @patient_count],
      "No" => [(entire_hypertension_population-hypertension), @patient_count]
    }

    resp

  end

  def handle_report_get(params)
    resp = {}
    resp = @@reports[params[:id].to_i]
    load_static_content
    load_report_data(resp)
    resp.to_json
  end

  # GET /reports
  def index
    if params[:id]
      handle_report_get(params)
      render :json => handle_report_get(params)
    else
      resp = {
        "populationCount" => Patient.count_by_sql("select count(*) from patients").to_s,
        "populationName" => "Lahey Clinic",
        "reports" => []
      }
      @@reports.values.each do |report|
        resp['reports'] << report
      end
      render :json => resp.to_json
    end
  end

  # GET /reports/1
  def show
    load_static_content
    render :json => handle_report_get(params)
  end

end