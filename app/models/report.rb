class Report < ActiveRecord::Base
  
  attr_accessor :numerator_request
  
  @@patient_count = Patient.count_by_sql("select count(distinct patients.id) from patients").to_i
  @@male = Gender.find_by_code('M')
  @@female = Gender.find_by_code('F')
  @@tobacco_use_and_exposure = SocialHistoryType.find_by_name("Tobacco use and exposure")
  @@valid_parameters = [:gender, :age, :medications, :blood_pressures, 
                         :therapies, :diabetes, :smoking, :hypertension, 
                         :ischemic_vascular_disease, :lipoid_disorder, 
                         :ldl_cholesterol, :colorectal_cancer_screening,
                         :mammography, :influenza_vaccine, :hb_a1c]

  def numerator_query=(val)
    @numerator_query = val
  end

  def denominator_query=(val)
    @denominator_query = val
  end

  def numerator_query
    self[:numerator_query].present? ? @numerator_query ||= YAML.load(self[:numerator_query]) : @numerator_query ||= {}  
    @numerator_query
  end

  def denominator_query
    self[:denominator_query].present? ? @denominator_query ||= YAML.load(self[:denominator_query]) : @denominator_query ||= {}
    @denominator_query
  end

  def save(*args)
    self[:denominator_query] = YAML.dump(denominator_query)
    self[:numerator_query] = YAML.dump(numerator_query)
    super(args)
  end
  
  def to_json_hash
    {:title => self.title,  :numerator => self.numerator, :denominator => self.denominator, :id => self.id,
      :numerator_fields => self.numerator_query, :denominator_fields => self.denominator_query}
  end
  
  def to_json(*args)
    to_json_hash.to_json
  end
  
  
  def self.patient_count 
    return @@patient_count || 0
  end
  
  def self.create_and_populate(params)
    reload_static_content
    
    if params[:id].blank? && (params[:numerator].present? || params[:denominator].present? || params[:title].present?)
      report = Report.new
      report.numerator_query = params[:numerator] || {}
      report.denominator_query = params[:denominator] || {}
      report.title = params[:title] || "Untitled Report"
      if !params[:denominator].blank? 
        report.denominator = count_patients(report.denominator_query)
      else
        report.denominator = @@patient_count
      end
      # @report.save <-- right now this just has the effect of saving the first change and nothing afterwards
    # create a blank report but don't save  
    elsif params[:id].blank? && params[:numerator].blank? && params[:denominator].blank? && params[:title].blank? 
      report = Report.new
      report.numerator_query =  {}
      report.denominator_query = {}
      report.denominator = @@patient_count
      report.title = "Untitled Report"
    elsif params[:id] # update an existing report
      report = find(params[:id])
      report.numerator_query = params[:numerator] || {}
      report.denominator_query = params[:denominator] || {}
      report.title = params[:title] if params[:title]
      report.denominator = count_patients(report.denominator_query)
    end
    
    # only run the numerator query if there are any fields provided
    if report.numerator_query.size > 0
      report.numerator = count_patients(merge_popconnect_request(report.denominator_query, report.numerator_query))
    else
      report.numerator = 0
    end
    
    return report
  end
  
  def self.all_and_populate(options = {})
    reports = all(options)
    reload_static_content
    reports.each do |item|
       item.denominator = (count_patients(item.denominator_query))
        # only run the numerator query if there are any fields provided
        if item.numerator_query.size > 0
          item.numerator = count_patients(merge_popconnect_request(item.denominator_query,
                                                                            item.numerator_query))
        else
          item.numerator = 0
        end
        item.save!
    end
    
    return reports
  end
  
  
  def self.reload_static_content
    @@patient_count = Patient.count_by_sql("select count(distinct patients.id) from patients").to_i
  end
  
  def self.find_and_populate(id)
    report = find(id)
    
    if report == nil
      return nil
    end
    
    reload_static_content
    
    report.denominator = (count_patients(report.denominator_query))
      # only run the numerator query if there are any fields provided
    if report.numerator_query.size > 0
      temp_request = merge_popconnect_request(report.denominator_query, report.numerator_query)
      report.numerator = count_patients(temp_request)
      report.numerator_request = temp_request
    else
      report.numerator = 0
    end
    return report
  end
  
  def self.find_and_generate_patients_query(id, prepend_sql = "")
      report = find_and_populate(id)
      if report.nil?
        return nil
      end
      return generate_population_query(report.numerator_request, prepend_sql)
  end
  
  def self.generate_new_join_table_hash_status
     join_tables = Hash["registration_information" =>                      false,
                         "medications aspirin" =>                          false,
                         "conditions hypertension" =>                      false,
                         "conditions diabetes" =>                          false,
                         "conditions ischemic_vascular_disease" =>         false,
                         "conditions lipoid_disorder" =>                   false,
                         "conditions smoking" =>                           false,
                         "conditions mammography" =>                       false,
                         "medications aspirin" =>                          false,
                         "social_history smoking_cessation" =>             false,
                         "abstract_results diastolic" =>                   false,
                         "abstract_results ldl_cholesterol" =>             false, 
                         "abstract_results colorectal_cancer_screening" => false,
                         "abstract_results hb_a1c" =>                      false,
                         "immunizations influenza_immunization" =>         false,
                         "vaccines influenza_vaccine" =>                   false]
   end
  
  def self.count_patients(report_request, load = false)
    if load
      reload_static_content
    end
    patient_count_with_ids(report_request).size
  end
  
  def self.patient_count_with_ids(report_request)
    ActiveRecord::Base.connection.select_values(generate_population_query(report_request))
  end
  
   # this merge is a little bit specialized, since it will do a careful merge of the values in
   # the hashs' arrays, where there will be no duplicate entries in the arrays, and no entries
   # will be deleted with the merge
   def self.merge_popconnect_request(hash1, hash2)
     resp = {}
     @@valid_parameters.each do |next_parameter|
       if (hash1.has_key?(next_parameter) || hash2.has_key?(next_parameter))
         resp[next_parameter] = merge_values(hash1, hash2, next_parameter)
       end
     end
     resp
   end

   def self.merge_values(hash1, hash2, key)
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
   
   
   def self.generate_population_query(request, prepend_sql = "SELECT DISTINCT patients.id FROM patients ")
     population_query = prepend_sql
     population_query = population_query + generate_from_sql(request, generate_new_join_table_hash_status())
     population_query = population_query + generate_where_sql(request, generate_new_join_table_hash_status())
     population_query
   end
   
   def self.generate_from_sql(request, from_tables)
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

     if request.has_key?(:colorectal_cancer_screening)
       if request[:colorectal_cancer_screening].include?("Yes")
         if from_tables["abstract_results colorectal_cancer_screening"] == false
           from_sql = from_sql + ", abstract_results colorectal_cancer_screening"
           from_tables["abstract_results colorectal_cancer_screening"] = true
         end
       end
     end

     if request.has_key?(:mammography)
       if request[:mammography].include?("Yes")
         if from_tables["conditions mammography"] == false
           from_sql = from_sql + ", conditions mammography"
           from_tables["conditions mammography"] = true
         end
       end
     end

     if request.has_key?(:influenza_vaccine)
       if request[:influenza_vaccine].include?("Yes")
         if from_tables["immunizations influenza_immunization"] == false
           from_sql = from_sql + ", immunizations influenza_immunization"
           from_tables["immunizations influenza_immunization"] = true
         end
         if from_tables["vaccines influenza_vaccine"] == false
           from_sql = from_sql + ", vaccines influenza_vaccine"
           from_tables["vaccines influenza_vaccine"] = true
         end
       end
     end

     if request.has_key?(:hb_a1c)
       if from_tables["abstract_results hb_a1c"] == false
         from_sql = from_sql + ", abstract_results hb_a1c"
         from_tables["abstract_results hb_a1c"] = true
       end
     end

     from_sql

   end

   def self.generate_where_sql(request, where_tables)
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
                       @@female.id.to_s + ") "
         end
         if next_gender_query == "Male"
           where_sql = where_sql + "(registration_information.gender_id = " + 
                       @@male.id.to_s + ") "
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
         if next_age_query == "<18"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE < (365*18)) "
         end
         if next_age_query == "18-30"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*18) "
           where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*30)) "
         end
         if next_age_query == "30-40"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*30) "
           where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*40)) "
         end
         if next_age_query == "40-50"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*40) "
           where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*50)) "
         end
         if next_age_query == "50-60"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*50) "
           where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*60)) "
         end
         if next_age_query == "60-70"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*60) "
           where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*70)) "
         end
         if next_age_query == "70-80"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*70) "
           where_sql = where_sql + "and now()::DATE - registration_information.date_of_birth::DATE < (365*80)) "
         end
         if next_age_query == "80+"
           where_sql = where_sql + "(now()::DATE - registration_information.date_of_birth::DATE >= (365*80)) "
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
                     @@tobacco_use_and_exposure.id.to_s + " "
       end
     end

     # OMG, please remind everyone that this is a feasibility demo... a.k.a. throwaway code!
     # If you are reading this comment and going WTF?, see me (McCready) and I'll buy you a
     # lunch as well as numerous shots of some form of alcholic liquid to explain what is 
     # going on here, and why I am working a Sunday... pissed that named scopes completely 
     # failed me on the popHealth work...  So sorry!!!
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
         #where_sql = where_sql + "and diabetes.free_text_name = 'Diabetes mellitus disorder' "
         where_sql = where_sql + "and diabetes.free_text_name like 'Diabetes mellitus%' "
       end
       if request[:diabetes].include?("No")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                    "select conditions.patient_id " +
                                    "from conditions " +
                                    #"where conditions.free_text_name = 'Diabetes mellitus disorder') "
                                  "where conditions.free_text_name like 'Diabetes mellitus%')"
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
         #where_sql = where_sql + "and hypertension.free_text_name = 'Essential hypertension disorder' "
         where_sql = where_sql + "and (hypertension.free_text_name like '%hypertension disorder%' "
         where_sql = where_sql + "or hypertension.free_text_name like '%Hypertensive disorder%' )"
       end
       if request[:hypertension].include?("No")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                 "select conditions.patient_id " +
                                 "from conditions " +
                                 #"where conditions.free_text_name = 'Essential hypertension disorder') "
                                 "where (conditions.free_text_name like '%hypertension disorder%' " + 
                                 "or conditions.free_text_name like '%Hypertensive disorder%')) "

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
         #where_sql = where_sql + "and ischemic_vascular_disease.free_text_name = 'Ischemia disorder' "
         where_sql = where_sql + "and ischemic_vascular_disease.free_text_name like 'Ischemia %' "
       end
       if request[:ischemic_vascular_disease].include?("No")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                 "select conditions.patient_id " +
                                 "from conditions " +
                                 #"where conditions.free_text_name = 'Ischemia disorder') "
                                 "where conditions.free_text_name like 'Ischemia %') "
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
         #where_sql = where_sql + "and lipoid_disorder.free_text_name = 'Hyperlipoproteinemia disorder' "
         where_sql = where_sql + "and lipoid_disorder.free_text_name like 'Hyperlipoproteinemia %' "
       end
       if request[:lipoid_disorder].include?("No")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                 "select conditions.patient_id " +
                                 "from conditions " +
                                 #"where conditions.free_text_name = 'Hyperlipoproteinemia disorder') "
                                 "where conditions.free_text_name like 'Hyperlipoproteinemia %') "
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
         #where_sql = where_sql + "and smoking.free_text_name = 'Smoker finding' "
         where_sql = where_sql + "and smoking.free_text_name like 'Smoker %' "
       end
       if request[:smoking].include?("Non-Smoker")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                 "select conditions.patient_id " +
                                 "from conditions " +
                                 #"where conditions.free_text_name = 'Smoker finding') "
                                 "where conditions.free_text_name like 'Smoker %') "
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
         elsif next_ldl_query == "180+"
           where_sql = where_sql + "(ldl_cholesterol.value_scalar::varchar::text::int > 180) "
         end
       end
       where_sql = where_sql + ")"
     end

     if request.has_key?(:colorectal_cancer_screening)
       if request[:colorectal_cancer_screening].include?("Yes")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         if where_tables["abstract_results colorectal_cancer_screening"] == false
           where_sql = where_sql + "colorectal_cancer_screening.patient_id = patients.id "
           where_tables["abstract_results colorectal_cancer_screening"] = true
         end
         where_sql = where_sql + "and colorectal_cancer_screening.result_code = '54047-6' "
       end
       if request[:colorectal_cancer_screening].include?("No")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                    "select abstract_results.patient_id " +
                                    "from abstract_results " +
                                    "where abstract_results.result_code = '54047-6') "
       end
     end

     if request.has_key?(:mammography)
       if request[:mammography].include?("Yes")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         if where_tables["conditions mammography"] == false
           where_sql = where_sql + "mammography.patient_id = patients.id "
           where_tables["conditions mammography"] = true
         end
         where_sql = where_sql + "and (mammography.free_text_name = 'Mammographic breast mass finding finding' "
         where_sql = where_sql + "or mammography.free_text_name = 'Mammography abnormal finding' "
         where_sql = where_sql + "or mammography.free_text_name = 'Mammography assessment Category 3    Probably benign finding short interval follow up finding' "
         where_sql = where_sql + "or mammography.free_text_name = 'Mammography normal finding') "
       end
       if request[:mammography].include?("No")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                   "select conditions.patient_id " +
                                   "from conditions " +
                                   "where (conditions.free_text_name = 'Mammographic breast mass finding finding' " +
                                   "or conditions.free_text_name = 'Mammography abnormal finding' " + 
                                   "or conditions.free_text_name = 'Mammography assessment Category 3    Probably benign finding short interval follow up finding' " + 
                                   "or conditions.free_text_name = 'Mammography normal finding')) "
       end
     end

     if request.has_key?(:influenza_vaccine)
       if request[:influenza_vaccine].include?("Yes")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         if where_tables["immunizations influenza_immunization"] == false
           where_sql = where_sql + "influenza_immunization.patient_id = patients.id "
           where_tables["immunizations influenza_immunization"] = true
         end
         if where_tables["vaccines influenza_vaccine"] == false
           where_sql = where_sql + "and influenza_immunization.vaccine_id = influenza_vaccine.id "
           where_tables["vaccines influenza_vaccine"] = true
         end
         where_sql = where_sql + "and influenza_vaccine.name like 'Influenza Virus Vaccine%' "
       end
       if request[:influenza_vaccine].include?("No")
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         start_using_and_keyword = true
         where_sql = where_sql + "patients.id not in (" + 
                                    "select immunizations.patient_id " +
                                    "from immunizations, vaccines " +
                                    "where immunizations.vaccine_id = vaccines.id " +
                                    "and vaccines.name like 'Influenza Virus Vaccine%') "
       end
     end

     if request.has_key?(:hb_a1c)
       if where_tables["abstract_results hb_a1c"] == false
         if start_using_and_keyword == true
           where_sql = where_sql + "and "
         end
         where_sql = where_sql + "hb_a1c.patient_id = patients.id "
         where_sql = where_sql + "and hb_a1c.result_code = '54039-3' "
         where_tables["abstract_results hb_a1c"] = true
         start_using_and_keyword = true
       end
       where_sql = where_sql + "and ("
       first_hb_a1c_query = true
       hb_a1c_requests = request[:hb_a1c]
       hb_a1c_requests.each do |next_hb_a1c_query|
         # or conditional query
         if first_hb_a1c_query == false
           where_sql = where_sql + "or "
         end
         first_hb_a1c_query = false
         if next_hb_a1c_query == "<7"
           where_sql = where_sql + "(hb_a1c.value_scalar::varchar::text::int <= 7) "
         elsif next_hb_a1c_query == "7-8"
           where_sql = where_sql + "(hb_a1c.value_scalar::varchar::text::int > 7 "
           where_sql = where_sql + "and hb_a1c.value_scalar::varchar::text::int <= 8) "
         elsif next_hb_a1c_query == "8-9"
           where_sql = where_sql + "(hb_a1c.value_scalar::varchar::text::int > 8 "
           where_sql = where_sql + "and hb_a1c.value_scalar::varchar::text::int <= 9) "
         elsif next_hb_a1c_query == "9+"
           where_sql = where_sql + "(hb_a1c.value_scalar::varchar::text::int > 9) "
         end
       end
       where_sql = where_sql + ")"
     end

     where_sql

   end



  # Build a PQRI document representing the report.
  #
  # @return [Builder::XmlMarkup] PQRI representation of report data
  def to_pqri(pqri_xml = nil)
    pqri_xml ||= Builder::XmlMarkup.new(:indent => 2)
    pqri_xml.submission("type" => "PQRI-REGISTRY", "option" => "PAYMENT", "version" => "1.0",
    "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
    "xsi:noNamespaceSchemaLocation" => "Registry_Payment.xsd") {

      pqri_xml.tag!('file-audit-data') {
        pqri_xml.tag! :'create-date', DateTime.now.strftime("%m-%d-%Y")
        pqri_xml.tag! :'create-time', DateTime.now.strftime("%H:%M")
        pqri_xml.tag! :'create-by', "popHealth"
        pqri_xml.tag! :version, "1.0"
        pqri_xml.tag! :'file-number', "1"
        pqri_xml.tag! :'number-of-files', "1"
      }

      pqri_xml.registry {
        pqri_xml.tag! :'registry-name', "Example Registry"
        pqri_xml.tag! :'registry-id', "000-exampleRegistryId"
        pqri_xml.tag! :'submission-period-from-date', "01-01-2009"
        pqri_xml.tag! :'submission-period-to-date', DateTime.now.strftime("%m-%d-%Y")
        pqri_xml.tag! :'submission-method', "A"
      }

      pqri_xml.tag! :'measure-group', "ID" => "X" do
        pqri_xml.provider {
          pqri_xml.npi("1234567890")
          pqri_xml.tin("Tax Id #")
          pqri_xml.tag! :'waiver-signed', "Y"
          pqri_xml.tag! :'pqri-measure' do
            pqri_xml.tag! :'pqri-measure-number', self.id.to_s + "-" + self.title 
            pqri_xml.tag! :'eligible-instances', self.denominator
            pqri_xml.tag! :'meets-performance-instances', self.numerator
            pqri_xml.tag! :'performance-exclusion-instances', 0
            pqri_xml.tag! :'performance-not-met-instances', (self.denominator - self.numerator)
            pqri_xml.tag! :'reporting-rate', "100.00"
            pqri_xml.tag! :'performance-rate', "%.2f" % (Float.induced_from(self.numerator) / Float.induced_from(self.denominator) * 100)
          end
        }
      end
    }
  end

end