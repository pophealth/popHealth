class ReportsController < ApplicationController

  # todo: this needs to be a final (immutable) variable
  @@valid_parameters = [:gender, :age, :medications, :blood_pressures, 
                        :therapies, :diabetes, :smoking, :hypertension, 
                        :ischemic_vascular_disease, :lipoid_disorder, 
                        :ldl_cholesterol, :colorectal_cancer_screening,
                        :mammography, :influenza_vaccine, :hb_a1c]
  
  # These are the hash parameters for loading specific fields, or one single metric on the database
  @@male_query_hash =                             {:gender => ['Male']}
  @@female_query_hash =                           {:gender => ['Female']}
  @@age_less_18query_hash =                       {:age => ['<18']}
  @@age_18_30_query_hash =                        {:age => ['18-30']}
  @@age_30_40_query_hash =                        {:age => ['30-40']}
  @@age_40_50_query_hash =                        {:age => ['40-50']}
  @@age_50_60_query_hash =                        {:age => ['50-60']}
  @@age_60_70_query_hash =                        {:age => ['60-70']}
  @@age_70_80_query_hash =                        {:age => ['70-80']}
  @@age_80_plus_query_hash =                      {:age => ['80+']}
  @@aspirin_query_hash =                          {:medications => 'Aspirin'}
  @@smoking_cessation_hash =                      {:therapies => 'Smoking Cessation'}  
  @@ldl_100_query_hash =                          {:ldl_cholesterol => '100'}
  @@ldl_100_120_query_hash =                      {:ldl_cholesterol => '100-120'}
  @@ldl_130_160_query_hash =                      {:ldl_cholesterol => '130-160'}
  @@ldl_160_180_query_hash =                      {:ldl_cholesterol => '160-180'}
  @@ldl_180_query_hash =                          {:ldl_cholesterol => '180+'}
  @@bp_110_70_query_hash =                        {:blood_pressures => '110/70'}
  @@bp_120_80_query_hash =                        {:blood_pressures => '120/80'}
  @@bp_140_90_query_hash =                        {:blood_pressures => '140/90'}
  @@bp_160_100_query_hash =                       {:blood_pressures => '160/100'}
  @@bp_180_110_query_hash =                       {:blood_pressures => '180/110+'}
  @@smoking_yes_query_hash =                      {:smoking => 'Current Smoker'}
  @@smoking_no_query_hash =                       {:smoking => 'Non-Smoker'}
  @@diabetic_yes_query_hash =                     {:diabetes => 'Yes'}
  @@diabetic_no_query_hash =                      {:diabetes => 'No'}
  @@hypertension_yes_query_hash =                 {:hypertension => 'Yes'}
  @@hypertension_no_query_hash =                  {:hypertension => 'No'}
  @@ischemic_vascular_disease_yes_query_hash =    {:ischemic_vascular_disease => 'Yes'}
  @@ischemic_vascular_disease_no_query_hash =     {:ischemic_vascular_disease => 'No'}
  @@lipoid_disorder_yes_query_hash =              {:lipoid_disorder => 'Yes'}
  @@lipoid_disorder_no_query_hash =               {:lipoid_disorder => 'No'}
  @@colorectal_cancer_screening_yes_query_hash =  {:colorectal_cancer_screening => 'Yes'}
  @@colorectal_cancer_screening_no_query_hash =   {:colorectal_cancer_screening => 'No'}
  @@mammography_yes_query_hash =                  {:mammography => 'Yes'}
  @@mammography_no_query_hash =                   {:mammography => 'No'}
  @@influenza_vaccine_yes_query_hash =            {:influenza_vaccine => 'Yes'}
  @@influenza_vaccine_no_query_hash =             {:influenza_vaccine => 'No'}
  @@hb_a1c_less_7_query_hash =                    {:hb_a1c => '<7'}
  @@hb_a1c_7_8_query_hash =                       {:hb_a1c => '7-8'}
  @@hb_a1c_8_9_query_hash =                       {:hb_a1c => '8-9'}
  @@hb_a1c_9_plus_query_hash =                    {:hb_a1c => '9+'}
  
  # GET /reports
  def index
    if params[:id]
      response = ""
      begin
            @report = Report.find_and_populate(params[:id])
            @report.save!
            resp = {}
            resp = @report.to_json_hash
            load_report_data(@report.numerator_query, resp, Report.patient_count)
            response = resp.to_json
      rescue => e
        response = "#{e}".to_json
      end
       render :json => response
    else
      # load the sidebar summary information
      response = ""
      begin
        @reports = Report.all_and_populate(:order => 'title asc')
        resp = {
          "populationCount" => Patient.count_by_sql("select count(*) from patients").to_s,
          "populationName" => "Sagacious Healthcare Services",
          "reports" => @reports
        }
        response = resp.to_json
      rescue => e
        response = "#{e}".to_json
      end
      render :json => response
    end
  end

  # POST /reports
  def create

    resp = {}
    
    response = ""
    begin
     @report = Report.create_and_populate(params) 
     resp = @report.to_json_hash
     resp = load_report_data(@report.numerator_query, resp, Report.patient_count)
     response = resp.to_json
    rescue => e
      response = "#{e}".to_json
    end
    render :json => response
  end
  
  def pqri_report
    @report = Report.find(params[:id])
    render 'pqri_report.xml', :layout => false
  end

  private
  
  # TODO: this method should be cached so the SQL only gets called when the DB is updated -shauni
  def load_report_data(report_parameters, resp = {}, patient_count = 0)

    resp[:count] = patient_count

    resp[:gender] = {
      'Male' =>   [Report.count_patients(@@male_query_hash), patient_count],
      'Female' => [Report.count_patients(@@female_query_hash), patient_count]
    }

    resp[:age] = {
      "<18" =>    [Report.count_patients(@@age_less_18query_hash),  patient_count],
      "18-30" =>  [Report.count_patients(@@age_18_30_query_hash),   patient_count],
      "30-40" =>  [Report.count_patients(@@age_30_40_query_hash),   patient_count],
      "40-50" =>  [Report.count_patients(@@age_40_50_query_hash),   patient_count],
      "50-60" =>  [Report.count_patients(@@age_50_60_query_hash),   patient_count],
      "60-70" =>  [Report.count_patients(@@age_60_70_query_hash),   patient_count],
      "70-80" =>  [Report.count_patients(@@age_70_80_query_hash),   patient_count],
      "80+" =>    [Report.count_patients(@@age_80_plus_query_hash), patient_count]
    }

    resp[:medications] = {
      "Aspirin" => [Report.count_patients(@@aspirin_query_hash), patient_count]
    }

    resp[:therapies] = {
      "Smoking Cessation" => [Report.count_patients(@@smoking_cessation_hash), patient_count]
    }

    resp[:ldl_cholesterol] = {
      "100" =>      [Report.count_patients(@@ldl_100_query_hash),     patient_count],
      "100-120" =>  [Report.count_patients(@@ldl_100_120_query_hash), patient_count],
      "130-160" =>  [Report.count_patients(@@ldl_130_160_query_hash), patient_count],
      "160-180" =>  [Report.count_patients(@@ldl_160_180_query_hash), patient_count],
      "180+" =>     [Report.count_patients(@@ldl_180_query_hash),     patient_count]
    }

    resp[:blood_pressures] = {
      "110/70" =>   [Report.count_patients(@@bp_110_70_query_hash),  patient_count],
      "120/80" =>   [Report.count_patients(@@bp_120_80_query_hash),  patient_count],
      "140/90" =>   [Report.count_patients(@@bp_140_90_query_hash),  patient_count],
      "160/100" =>  [Report.count_patients(@@bp_160_100_query_hash), patient_count],
      "180/110+" => [Report.count_patients(@@bp_180_110_query_hash), patient_count]
    }
    
    resp[:smoking] = {
      "Current Smoker" =>  [Report.count_patients(@@smoking_yes_query_hash), patient_count],
      "Non-Smoker" =>   [Report.count_patients(@@smoking_no_query_hash),     patient_count]
    }

    resp[:diabetes] = {
      "Yes" =>  [Report.count_patients(@@diabetic_yes_query_hash), patient_count],
      "No" =>   [Report.count_patients(@@diabetic_no_query_hash),  patient_count]
    }

    resp[:hypertension] = {
      "Yes" =>  [Report.count_patients(@@hypertension_yes_query_hash), patient_count],
      "No" =>   [Report.count_patients(@@hypertension_no_query_hash),  patient_count]
    }

    resp[:ischemic_vascular_disease] = {
      "Yes" =>  [Report.count_patients(@@ischemic_vascular_disease_yes_query_hash), patient_count],
      "No" =>   [Report.count_patients(@@ischemic_vascular_disease_no_query_hash),  patient_count]
    }
    
    resp[:lipoid_disorder] = {
      "Yes" =>  [Report.count_patients(@@lipoid_disorder_yes_query_hash), patient_count],
      "No" =>   [Report.count_patients(@@lipoid_disorder_no_query_hash),  patient_count]
    }

    resp[:colorectal_cancer_screening] = {
      "Yes" =>  [Report.count_patients(@@colorectal_cancer_screening_yes_query_hash), patient_count],
      "No" =>   [Report.count_patients(@@colorectal_cancer_screening_no_query_hash),  patient_count]
    }

    resp[:mammography] = {
      "Yes" =>  [Report.count_patients(@@mammography_yes_query_hash), patient_count],
      "No" =>   [Report.count_patients(@@mammography_no_query_hash),  patient_count]
    }

    resp[:influenza_vaccine] = {
      "Yes" =>  [Report.count_patients(@@influenza_vaccine_yes_query_hash), patient_count],
      "No" =>   [Report.count_patients(@@influenza_vaccine_no_query_hash),  patient_count]
    }
    
    resp[:hb_a1c] = {
      "<7" =>   [Report.count_patients(@@hb_a1c_less_7_query_hash),  patient_count],
      "7-8" =>  [Report.count_patients(@@hb_a1c_7_8_query_hash),     patient_count],
      "8-9" =>  [Report.count_patients(@@hb_a1c_8_9_query_hash),     patient_count],
      "9+" =>   [Report.count_patients(@@hb_a1c_9_plus_query_hash),  patient_count]
    }

    resp
  end
  
end