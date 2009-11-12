class ReportsController < ApplicationController

  # todo: this needs to be a final (immutable) variable
  @@valid_parameters = [:gender, :age, :medications, :blood_pressures, :therapies, :diabetes,
                        :smoking, :hypertension, :ischemic_vascular_disease, 
                        :lipoid_disorder, :ldl_cholesterol]

  @@reports = {
    1 => {
      :title => 'Aspirin Therapy',
      :numerator => 229,
      :denominator => 667,
      :denominator_fields => {:age => ['35-49', '50-64', '65-75', '76+'], :diabetes => ['Yes']},
      :numerator_fields => {:medications => ['Aspirin']},
      :id => 1
    },
    2 => {
      :title => 'BP Control 1',
      :numerator => 267,
      :denominator => 495,
      :denominator_fields => {:age => ['18-34', '35-49', '50-64', '65-75', '76+'], :hypertension => ['Yes'], :ischemic_vascular_disease => ['No']},
      :numerator_fields => {:blood_pressures => ['110/70', '120/80', '140/90']},
      :id => 2
    },
    3 => {
      :title => 'BP Control 2',
      :numerator => 32,
      :denominator => 96,
      :denominator_fields => {:age => ['18-34', '35-49', '50-64', '65-75', '76+'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['110/70', '120/80']},
      :id => 3
    },
    4 => {
      :title => 'BP Control 3',
      :numerator => 14,
      :denominator => 96,
      :denominator_fields => {:age => ['18-34', '35-49', '50-64', '65-75', '76+'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['120/80']},
      :id => 4
    },
    5 => {
      :title => 'Cholesterol Control 1',
      :numerator => 8,
      :denominator => 37,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75', '76+'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['120/80']},
      :id => 5
    },
    6 => {
      :title => 'Cholesterol Control 2',
      :numerator => 8,
      :denominator => 37,
      :denominator_fields => {:gender => ['Male', 'Female'], :age => ['18-34', '35-49', '50-64', '65-75', '76+'], :diabetes => ['Yes'], :hypertension => ['Yes']},
      :numerator_fields => {:blood_pressures => ['120/80']},
      :id => 6
    },
    7 => {
      :title => 'Smoking Cessation',
      :numerator => 292,
      :denominator => 673,
      :denominator_fields => {:gender => ['Female'], :age => ['18-34', '35-49', '50-64', '65-75', '76+'], :smoking => ['Current Smoker']},
      :numerator_fields => {:therapies => ['Smoking Cessation']},
      :id => 7
    }
  }

  # todo *rjm
  # This entire method can be replaced by passing the proper prameters to 
  # the generate_report method
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
      "Smoking Cessation" => [Patient.count_by_sql("select count(*)                               " +
                                                   "from patients, social_history                 " +
                                                   "where social_history.patient_id = patients.id " +
                                                   "and social_history.social_history_type_id =   " + 
                                                   @tobacco_use_and_exposure.id.to_s).to_i, @patient_count],
    }

    resp[:ldl_cholesterol] = {
      "100" => [Patient.count_by_sql("select count(*)                                           " +
                                      "from patients, abstract_results ldl_cholesterol           " +
                                      "where ldl_cholesterol.patient_id = patients.id            " +
                                      "and ldl_cholesterol.result_code = '18261-8'               " + 
                                      "and ldl_cholesterol.value_scalar::varchar::text::int <= 100"), @patient_count],
      "100-120" => [Patient.count_by_sql("select count(*)                                            " +
                                         "from patients, abstract_results ldl_cholesterol            " +
                                         "where ldl_cholesterol.patient_id = patients.id             " +
                                         "and ldl_cholesterol.result_code = '18261-8'                " + 
                                         "and ldl_cholesterol.value_scalar::varchar::text::int > 100 " + 
                                          "and ldl_cholesterol.value_scalar::varchar::text::int <= 120"), @patient_count],
      "130-160" => [Patient.count_by_sql("select count(*)                                            " +
                                         "from patients, abstract_results ldl_cholesterol            " +
                                         "where ldl_cholesterol.patient_id = patients.id             " +
                                         "and ldl_cholesterol.result_code = '18261-8'                " + 
                                         "and ldl_cholesterol.value_scalar::varchar::text::int > 130 " + 
                                          "and ldl_cholesterol.value_scalar::varchar::text::int <= 160"), @patient_count],
      "160-180" => [Patient.count_by_sql("select count(*)                                            " +
                                         "from patients, abstract_results ldl_cholesterol            " +
                                         "where ldl_cholesterol.patient_id = patients.id             " +
                                         "and ldl_cholesterol.result_code = '18261-8'                " + 
                                         "and ldl_cholesterol.value_scalar::varchar::text::int > 160 " + 
                                         "and ldl_cholesterol.value_scalar::varchar::text::int <= 180"), @patient_count],
      "180+" => [Patient.count_by_sql("select count(*)                                            " +
                                         "from patients, abstract_results ldl_cholesterol            " +
                                         "where ldl_cholesterol.patient_id = patients.id             " +
                                         "and ldl_cholesterol.result_code = '18261-8'                " + 
                                         "and ldl_cholesterol.value_scalar::varchar::text::int > 180"), @patient_count]
    }

    resp[:blood_pressures] = {
      "110/70" => [Patient.count_by_sql("select count(*)                                      " +
                                        "from patients, abstract_results diastolic            " +
                                        "where diastolic.patient_id = patients.id " +
                                        "and diastolic.result_code = '8462-4' " + 
                                        "and diastolic.value_scalar::varchar::text::int >= 70 " +
                                        "and diastolic.value_scalar::varchar::text::int <= 79"), @patient_count],
      "120/80" => [Patient.count_by_sql("select count(*)                                      " +
                                        "from patients, abstract_results diastolic            " +
                                        "where diastolic.patient_id = patients.id " +
                                        "and diastolic.result_code = '8462-4' " + 
                                        "and diastolic.value_scalar::varchar::text::int >= 75 " +
                                        "and diastolic.value_scalar::varchar::text::int <= 84"), @patient_count],
      "140/90" => [Patient.count_by_sql("select count(*)                                      " +
                                        "from patients, abstract_results diastolic            " +
                                        "where diastolic.patient_id = patients.id " +
                                        "and diastolic.result_code = '8462-4' " + 
                                        "and diastolic.value_scalar::varchar::text::int >= 85 " +
                                        "and diastolic.value_scalar::varchar::text::int <= 94"), @patient_count],
      "160/100" => [Patient.count_by_sql("select count(*)                                     " +
                                         "from patients, abstract_results diastolic           " +
                                         "where diastolic.patient_id = patients.id " +
                                         "and diastolic.result_code = '8462-4' " + 
                                         "and diastolic.value_scalar::varchar::text::int >= 95 " +
                                         "and diastolic.value_scalar::varchar::text::int <= 104"), @patient_count],
      "180/110+" => [Patient.count_by_sql("select count(*)                                    " +
                                         "from patients, abstract_results diastolic           " +
                                         "where diastolic.patient_id = patients.id " +
                                         "and diastolic.result_code = '8462-4' " + 
                                         "and diastolic.value_scalar::varchar::text::int >= 105 " +
                                         "and diastolic.value_scalar::varchar::text::int <= 114"), @patient_count]
    }

    # smoking
    smokers = Patient.count_by_sql("select count(*)                           " +
                                   "from patients, conditions                 " +
                                   "where conditions.patient_id = patients.id " +
                                   "and conditions.free_text_name = 'Diabetes mellitus disorder'")
    resp[:smoking] = {
      "Current Smoker" => [smokers, @patient_count],
      "Non-Smoker"  => [(@patient_count-smokers), @patient_count]
    }

    # diabetes
    diabetics = Patient.count_by_sql("select count(*)                           " +
                                     "from patients, conditions                 " +
                                     "where conditions.patient_id = patients.id " +
                                     "and conditions.free_text_name = 'Diabetes mellitus disorder'")
    resp[:diabetes] = {
      "Yes" => [diabetics, @patient_count],
      "No" => [(@patient_count-diabetics), @patient_count]
    }

    # hypertension
    hypertension = Patient.count_by_sql("select count(*)                           " +
                                        "from patients, conditions                 " +
                                        "where conditions.patient_id = patients.id " +
                                        "and conditions.free_text_name = 'Essential hypertension disorder'")
    resp[:hypertension] = {
      "Yes" => [hypertension, @patient_count],
      "No" => [(@patient_count-hypertension), @patient_count]
    }

    ischemic_vascular_disease = Patient.count_by_sql("select count(*)                           " +
                                                     "from patients, conditions                 " +
                                                     "where conditions.patient_id = patients.id " +
                                                     "and conditions.free_text_name = 'Ischemia disorder'")
    resp[:ischemic_vascular_disease] = {
      "Yes" => [ischemic_vascular_disease, @patient_count],
      "No" => [(@patient_count-ischemic_vascular_disease), @patient_count]
    }

    entire_lipoid_disorder_population = @patient_count
    lipoid_disorder = Patient.count_by_sql("select count(*)                           " +
                                           "from patients, conditions                 " +
                                           "where conditions.patient_id = patients.id " +
                                           "and conditions.free_text_name = 'Hyperlipoproteinemia disorder'")
    resp[:lipoid_disorder] = {
      "Yes" => [lipoid_disorder, @patient_count],
      "No" =>[(@patient_count-lipoid_disorder), @patient_count]
    }

    resp

  end

  # GET /reports
  def index
    if params[:id]
      generate_report(@@reports[params[:id].to_i][:denominator_fields])
      render :json => handle_report_get(params)
    else
      # load the sidebar summary information
      resp = {
        "populationCount" => Patient.count_by_sql("select count(*) from patients").to_s,
        "populationName" => "Columbia Road Health Services",
        "reports" => []
      }
      # this eventually needs to come from the DB
      @@reports.values.each do |report|
        resp['reports'] << report
      end
      render :json => resp.to_json
    end
  end

  # POST /reports
  def create
    resp = {}

    # create a new report
    if params[:id].blank? && (!params[:numerator].blank? || !params[:denominator].blank? || !params[:title].blank?)
      params[:id] = @@reports.length + 1
      @@reports[params[:id]] = {}
      @@reports[params[:id]][:title] = "Untitled Report " + (@@reports.values.select {|r| r[:title] =~ /Untitled Report /}.length + 1).to_s
      @@reports[params[:id]][:id] = params[:id]
    end

    # update an existing report
    if params[:id]
      params[:id] = params[:id].to_i
      @@reports[params[:id]][:numerator_fields] = params[:numerator] || {}
      @@reports[params[:id]][:denominator_fields] = params[:denominator] || {}
      @@reports[params[:id]][:title] = params[:title] if params[:title]
      @@reports[params[:id]][:numerator] = @@reports[params[:id]][:numerator_fields].length > 0 ? rand(1000) : 0
      @@reports[params[:id]][:denominator] = generate_report(@@reports[params[:id].to_i][:denominator_fields])
      # only run the numerator query if there are any fields provided
      if @@reports[params[:id].to_i][:numerator_fields].size > 0
        @@reports[params[:id]][:numerator] = generate_report(merge_popconnect_request(@@reports[params[:id].to_i][:denominator_fields],
                                                                                      @@reports[params[:id].to_i][:numerator_fields]))
      else
        @@reports[params[:id]][:numerator] = 0
      end
    end

    resp = @@reports[params[:id].to_i]
    load_static_content
    load_report_data(resp)
    render :json => resp.to_json
  end

  private

  def handle_report_get(params)
    resp = {}
    resp = @@reports[params[:id].to_i]
    load_static_content
    load_report_data(resp)
    resp.to_json
  end

  def generate_report(report_request)
    Patient.count_by_sql(generate_population_query(report_request))
  end

  # this merge is a little bit specialized, since it will do a careful merge of the values in
  # the hashs' arrays, where there will be no duplicate entries in the arrays, and no entries
  # will be deleted with the merge
  def merge_popconnect_request(hash1, hash2)
    resp = {}
    @@valid_parameters.each do |next_parameter|
      if (hash1.has_key?(next_parameter) || hash2.has_key?(next_parameter))
        resp[next_parameter] = merge_values(hash1, hash2, next_parameter)
      end
    end
    resp
  end
  
  def merge_values(hash1, hash2, key)
    merged_values = Array.new()
    # only hash 1 has key, and hash 2 does not
    if (hash1.has_key?(key) && !hash2.has_key?(key))
      merged_values = hash1[key]
    # only hash 2 has key, and hash 1 does not
    elsif (!hash1.has_key?(key) && hash2.has_key?(key))
      merged_values = hash2[key]
    # both hash 1 has key, and hash 2 has key
    elsif (hash1.has_key?(key) && hash2.has_key?(key))
      merged_values = (hash1[key]) + (hash2[key])
      merged_values = merged_values.uniq
    end
    merged_values
  end

  def load_static_content
    @patient_count = Patient.count_by_sql("select count(distinct patients.id) from patients").to_i
    @male = Gender.find_by_code('M')
    @female = Gender.find_by_code('F')
    @tobacco_use_and_exposure = SocialHistoryType.find_by_name("Tobacco use and exposure")
  end

  # this is the list of tables which could need to joint with the patient record table
  # this is used to generate the SQL select statement efficiently
  def generate_new_join_table_hash_status
    load_static_content
    join_tables = Hash["registration_information" =>              false,
                        "medications aspirin" =>                  false,
                        "conditions hypertension" =>              false,
                        "conditions diabetes" =>                  false,
                        "conditions ischemic_vascular_disease" => false,
                        "conditions lipoid_disorder" =>           false,
                        "conditions smoking" =>                   false,
                        "medications aspirin" =>                  false,
                        "social_history smoking_cessation" =>     false,
                        "abstract_results diastolic" =>           false,
                        "abstract_results ldl_cholesterol" =>     false]
  end

  def generate_population_query(request)
    population_query = "select count(distinct patients.id) from patients"
    population_query = population_query + generate_from_sql(request, generate_new_join_table_hash_status())
    population_query = population_query + generate_where_sql(request, generate_new_join_table_hash_status())
    puts "The query22 is " + population_query
    return population_query
  end

  def generate_from_sql(request, from_tables)

    from_sql = ""

    if request.has_key?(:gender)
      if from_tables["registration_information"] == false
        from_sql = from_sql + ", registration_information"
        from_tables["registration_information"] = true
      end
    end

    if request.has_key?(:age)
      if from_tables["registration_information"] == false
        from_sql = from_sql + ", registration_information"
        from_tables["registration_information"] = true
      end
    end

    if request.has_key?(:therapies)
      if request[:therapies].include?("Smoking Cessation")
        if from_tables["social_history smoking_cessation"] == false
          from_sql = from_sql + ", social_history smoking_cessation"
          from_tables["social_history smoking_cessation"] = true
        end
      end
    end

    if request.has_key?(:diabetes)
      if request[:diabetes].include?("Yes")
        if from_tables["conditions diabetes"] == false
          from_sql = from_sql + ", conditions diabetes"
          from_tables["conditions diabetes"] = true
        end
      end
    end

    if request.has_key?(:hypertension)
      if request[:hypertension].include?("Yes")
        if from_tables["conditions hypertension"] == false
          from_sql = from_sql + ", conditions hypertension"
          from_tables["conditions hypertension"] = true
        end
      end
    end

    if request.has_key?(:ischemic_vascular_disease)
      if request[:ischemic_vascular_disease].include?("Yes")
        if from_tables["conditions ischemic_vascular_disease"] == false
          from_sql = from_sql + ", conditions ischemic_vascular_disease"
          from_tables["conditions ischemic_vascular_disease"] = true
        end
      end
    end

    if request.has_key?(:lipoid_disorder)
      if request[:lipoid_disorder].include?("Yes")
        if from_tables["conditions lipoid_disorder"] == false
          from_sql = from_sql + ", conditions lipoid_disorder"
          from_tables["conditions lipoid_disorder"] = true
        end
      end
    end

    if request.has_key?(:smoking)
      if request[:smoking].include?("Current Smoker")
        if from_tables["conditions smoking"] == false
          from_sql = from_sql + ", conditions smoking"
          from_tables["conditions smoking"] = true
        end
      end
    end

    if request.has_key?(:medications)
      medications = request[:medications]
      medications.each do |next_medication|
        if next_medication == "Aspirin"
          if from_tables["medications aspirin"] == false
            from_sql = from_sql + ", medications aspirin"
            from_tables["medications aspirin"] = true
          end
        end
      end
    end

    if request.has_key?(:ldl_cholesterol)
      if from_tables["abstract_results ldl_cholesterol"] == false
        from_sql = from_sql + ", abstract_results ldl_cholesterol"
        from_tables["abstract_results ldl_cholesterol"] = true
      end
    end

    if request.has_key?(:blood_pressures)
      if from_tables["abstract_results diastolic"] == false
        from_sql = from_sql + ", abstract_results diastolic"
        from_tables["abstract_results diastolic"] = true
      end
    end

    from_sql

  end

  def generate_where_sql(request, where_tables)

    where_sql = ""

    if request.size > 0
      where_sql = where_sql + " where "
    else
      return ""
    end

    start_using_and_keyword = false

    if request.has_key?(:gender)
      if where_tables["registration_information"] == false
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        where_sql = where_sql + "registration_information.patient_id = patients.id "
        where_tables["registration_information"] = true
        start_using_and_keyword = true
      end

      where_sql = where_sql + "and ("
      gender_requests = request[:gender]
      first_gender_query = true
      gender_requests.each do |next_gender_query|
        # or conditional query
        if first_gender_query == false
          where_sql = where_sql + "or "
        else
          first_gender_query = false
        end
        if next_gender_query == "Female"
          where_sql = where_sql + "(registration_information.gender_id = " + 
                      @female.id.to_s + ") "
        end
        if next_gender_query == "Male"
          where_sql = where_sql + "(registration_information.gender_id = " + 
                      @male.id.to_s + ") "
        end
      end
      where_sql = where_sql + ")"
    end

    if request.has_key?(:age)
      if where_tables["registration_information"] == false
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        where_sql = where_sql + "registration_information.patient_id = patients.id "
        where_tables["registration_information"] = true
        start_using_and_keyword = true
      end

      where_sql = where_sql + "and ("
      first_age_query = true
      age_requests = request[:age]
      age_requests.each do |next_age_query|
        # or conditional query
        if first_age_query == false
          where_sql = where_sql + "or "
        end
        first_age_query = false
        if next_age_query == "18-34"
          where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*18) "
          where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*35)) "
        end
        if next_age_query == "35-49"
          where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*35) "
          where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*50)) "
        end
        if next_age_query == "50-64"
          where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*50) "
          where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*65)) "
        end
        if next_age_query == "65-75"
          where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*65) "
          where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*76)) "
        end
        if next_age_query == "76+"
          where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*76)) "
        end
      end
      where_sql = where_sql + ")"
    end

    if request.has_key?(:therapies)
      if request[:therapies].include?("Smoking Cessation")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        if where_tables["social_history smoking_cessation"] == false
          where_sql = where_sql + "smoking_cessation.patient_id = patients.id "
          where_tables["social_history smoking_cessation"] = true
        end
        where_sql = where_sql + "and smoking_cessation.social_history_type_id = " + 
                    @tobacco_use_and_exposure.id.to_s + " "
      end
    end

    # OMG, please remind everyone that this is a feasibility demo... a.k.a. throwaway code!
    # If you are reading this comment and going WTF?, see me (McCready) and I'll buy you a
    # lunch as well as numerous shots of some form of alcholic liquid to explain what is 
    # going on here, and why I am working a Sunday... pissed that named scopes completely 
    # failed me on the popConnect work...  So sorry!!!
    if request.has_key?(:diabetes)
      if request[:diabetes].include?("Yes")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        if where_tables["conditions diabetes"] == false
          where_sql = where_sql + "diabetes.patient_id = patients.id "
          where_tables["conditions diabetes"] = true
        end
        where_sql = where_sql + "and diabetes.free_text_name = 'Diabetes mellitus disorder' "
      end
      if request[:diabetes].include?("No")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        where_sql = where_sql + "patients.id not in (" + 
                                   "select conditions.patient_id " +
                                   "from conditions " +
                                   "where conditions.free_text_name = 'Diabetes mellitus disorder') "
      end
    end

    # see comment on diabetes query generation *rjm
    if request.has_key?(:hypertension)
      if request[:hypertension].include?("Yes")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        if where_tables["conditions hypertension"] == false
          where_sql = where_sql + "hypertension.patient_id = patients.id "
          where_tables["conditions hypertension"] = true
        end
        where_sql = where_sql + "and hypertension.free_text_name = 'Essential hypertension disorder' "
      end
      if request[:hypertension].include?("No")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        where_sql = where_sql + "patients.id not in (" + 
                                "select conditions.patient_id " +
                                "from conditions " +
                                "where conditions.free_text_name = 'Essential hypertension disorder') "
      end
    end

    # see comment on diabetes query generation *rjm
    if request.has_key?(:ischemic_vascular_disease)
      if request[:ischemic_vascular_disease].include?("Yes")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        if where_tables["conditions ischemic_vascular_disease"] == false
          where_sql = where_sql + "ischemic_vascular_disease.patient_id = patients.id "
          where_tables["conditions ischemic_vascular_disease"] = true
        end
        where_sql = where_sql + "and ischemic_vascular_disease.free_text_name = 'Ischemia disorder' "
      end
      if request[:ischemic_vascular_disease].include?("No")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        where_sql = where_sql + "patients.id not in (" + 
                                "select conditions.patient_id " +
                                "from conditions " +
                                "where conditions.free_text_name = 'Ischemia disorder') "
      end
    end

    # see comment on diabetes query generation *rjm
    if request.has_key?(:lipoid_disorder)
      if request[:lipoid_disorder].include?("Yes")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        if where_tables["conditions lipoid_disorder"] == false
          where_sql = where_sql + "lipoid_disorder.patient_id = patients.id "
          where_tables["conditions lipoid_disorder"] = true
        end
        where_sql = where_sql + "and lipoid_disorder.free_text_name = 'Hyperlipoproteinemia disorder' "
      end
      if request[:lipoid_disorder].include?("No")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        where_sql = where_sql + "patients.id not in (" + 
                                "select conditions.patient_id " +
                                "from conditions " +
                                "where conditions.free_text_name = 'Hyperlipoproteinemia disorder') "
      end
    end

    # see comment on diabetes query generation *rjm
    if request.has_key?(:smoking)
      if request[:smoking].include?("Current Smoker")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        if where_tables["conditions smoking"] == false
          where_sql = where_sql + "smoking.patient_id = patients.id "
          where_tables["conditions smoking"] = true
        end
        where_sql = where_sql + "and smoking.free_text_name = 'Smoker finding' "
      end
      if request[:smoking].include?("Non-Smoker")
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        start_using_and_keyword = true
        where_sql = where_sql + "patients.id not in (" + 
                                "select conditions.patient_id " +
                                "from conditions " +
                                "where conditions.free_text_name = 'Smoker finding') "
      end
    end

    if request.has_key?(:medications)
      medications = request[:medications]
      medications.each do |next_medication|
        if next_medication == "Aspirin"
          if where_tables["medications aspirin"] == false
            if start_using_and_keyword == true
              where_sql = where_sql + "and "
            end
            where_sql = where_sql + "aspirin.patient_id = patients.id "
            where_tables["medications aspirin"] = true
            start_using_and_keyword = true
          end
          where_sql = where_sql + "and aspirin.product_code = 'R16CO5Y76E' "
        end
      end
    end

    if request.has_key?(:blood_pressures)
      if where_tables["abstract_results diastolic"] == false
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        where_sql = where_sql + "diastolic.patient_id = patients.id "
        where_sql = where_sql + "and diastolic.result_code = '8462-4' "
        where_tables["abstract_results diastolic"] = true
        start_using_and_keyword = true
      end

      where_sql = where_sql + "and ("
      first_blood_pressure_query = true
      blood_pressure_requests = request[:blood_pressures]
      blood_pressure_requests.each do |next_bp_query|
        # or conditional query
        if first_blood_pressure_query == false
          where_sql = where_sql + "or "
        end
        first_blood_pressure_query = false

        if next_bp_query == "110/70"
          where_sql = where_sql + "(diastolic.value_scalar::varchar::text::int <= 74) "
        end
        if next_bp_query == "120/80"
          where_sql = where_sql + "(diastolic.value_scalar::varchar::text::int >= 75 "
          where_sql = where_sql + "and diastolic.value_scalar::varchar::text::int <= 84) "
        end
        if next_bp_query == "140/90"
          where_sql = where_sql + "(diastolic.value_scalar::varchar::text::int >= 85 "
          where_sql = where_sql + "and diastolic.value_scalar::varchar::text::int <= 94) "
        end
        if next_bp_query == "160/100"
          where_sql = where_sql + "(diastolic.value_scalar::varchar::text::int >= 95 "
          where_sql = where_sql + "and diastolic.value_scalar::varchar::text::int <= 104) "
        end
        if next_bp_query == "180/110+"
          where_sql = where_sql + "(diastolic.value_scalar::varchar::text::int >= 105) "
        end
      end
      where_sql = where_sql + ")"
    end

    if request.has_key?(:ldl_cholesterol)
      if where_tables["abstract_results ldl_cholesterol"] == false
        if start_using_and_keyword == true
          where_sql = where_sql + "and "
        end
        where_sql = where_sql + "ldl_cholesterol.patient_id = patients.id "
        where_sql = where_sql + "and ldl_cholesterol.result_code = '18261-8' "
        where_tables["abstract_results ldl_cholesterol"] = true
        start_using_and_keyword = true
      end

      where_sql = where_sql + "and ("
      first_ldl_query = true
      ldl_requests = request[:ldl_cholesterol]
      ldl_requests.each do |next_ldl_query|
        # or conditional query
        if first_ldl_query == false
          where_sql = where_sql + "or "
        end
        first_ldl_query = false

        if next_ldl_query == "100"
          where_sql = where_sql + "(ldl_cholesterol.value_scalar::varchar::text::int <= 100) "
        elsif next_ldl_query == "100-120"
          where_sql = where_sql + "(ldl_cholesterol.value_scalar::varchar::text::int > 100 "
          where_sql = where_sql + "and ldl_cholesterol.value_scalar::varchar::text::int <= 120) "
        elsif next_ldl_query == "130-160"
          where_sql = where_sql + "(ldl_cholesterol.value_scalar::varchar::text::int > 130 "
          where_sql = where_sql + "and ldl_cholesterol.value_scalar::varchar::text::int <= 160) "
        elsif next_ldl_query == "160-180"
          where_sql = where_sql + "(ldl_cholesterol.value_scalar::varchar::text::int > 160 "
          where_sql = where_sql + "and ldl_cholesterol.value_scalar::varchar::text::int <= 180) "
        elsif next_bp_query == "180+"
          where_sql = where_sql + "(ldl_cholesterol.value_scalar::varchar::text::int > 180) "
        end
      end
      where_sql = where_sql + ")"
    end

    where_sql

  end

end