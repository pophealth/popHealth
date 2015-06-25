module Api
  class QueriesController  < ApplicationController
    resource_description do
      short 'Queries'
      formats ['json']
      description <<-QCDESC
        This resource is responsible for managing clinical quality measure calculations. Creating a new query will kick
        off a new CQM calculation (if it hasn't already been calculated). You can determine the status of ongoing
        calculations, force recalculations and see results through this resource.
      QCDESC
    end
    include PaginationHelper
    skip_authorization_check
    before_filter :authenticate_user!
    before_filter :set_pagination_params, :only=>[:patient_results, :patients]

    def index
      filter = {}
      filter["hqmf_id"] = {"$in" => params["measure_ids"]} if params["measure_ids"]
      providers = collect_provider_id
      filter["filters.providers"] = {"$in" => providers} if providers
      render json: QME::QualityReport.where(filter)
    end

    api :GET, '/queries/:id', "Retrieve clinical quality measure calculation"
    param :id, String, :desc => 'The id of the quality measure calculation', :required => true
    example '{"DENEX":0,"DENEXCEP":0,"DENOM":5,"IPP":5,"MSRPOPL":0,"NUMER":0,  "status":{"state":"completed", ...}, ...}'
    description "Gets a clinical quality measure calculation. If calculation is completed, the response will include the results."
    def show
      @qr = QME::QualityReport.find(params[:id])

      if current_user.preferences.show_aggregate_result && !@qr.aggregate_result && !APP_CONFIG['use_opml_structure'] 
        cv = @qr.measure.continuous_variable
        aqr = QME::QualityReport.where(measure_id: @qr.measure_id, sub_id: @qr.sub_id, 'filters.providers' => [Provider.root._id.to_s], effective_date: @qr.effective_date).first  	           
        if aqr.result
          if cv 
            @qr.aggregate_result = aqr.result.OBSERV
          else
            @qr.aggregate_result = (aqr.result.DENOM > 0)? (100*((aqr.result.NUMER).to_f / (aqr.result.DENOM - aqr.result.DENEXCEP - aqr.result.DENEX).to_f)).round : 0
          end
	        @qr.save!
        end
      end

      authorize! :read, @qr
      render json: @qr
    end

    api :POST, '/queries', "Start a clinical quality measure calculation"
    param :measure_id, String, :desc => 'The HQMF id for the CQM to calculate', :required => true
    param :sub_id, String, :desc => 'The sub id for the CQM to calculate. This is popHealth specific.', :required => false,:allow_nil => true
    param :effective_date, ->(effective_date){ effective_date.present? }, :desc => 'Time in seconds since the epoch for the end date of the reporting period',
                                   :required => true
    param :providers, Array, :desc => 'An array of provider IDs to filter the query by', :allow_nil => true
    example '{"_id":"52fe409bb99cc8f818000001", "status":{"state":"queued", ...}, ...}'
    description <<-CDESC
      This action will create a clinical quality measure calculation. If the measure has already been calculated,
      it will return the results. If not, it will return the status of the calculation, which can be checked in
      the status property of the returned JSON. If it is calculating, then the results may be obtained by the
      GET action with the id.
    CDESC
    def create
      options = {}
      options[:filters] = build_filter

      authorize_providers

      options[:effective_date] = params[:effective_date]
      options['prefilter'] = build_mr_prefilter if APP_CONFIG['use_map_reduce_prefilter']
      qr = QME::QualityReport.find_or_create(params[:measure_id],
                                           params[:sub_id], options)
      if !qr.calculated?
        qr.calculate( {"oid_dictionary" =>OidHelper.generate_oid_dictionary(qr.measure),
          "enable_rationale" => APP_CONFIG['enable_map_reduce_rationale'] || false,
          "enable_logging" => APP_CONFIG['enable_map_reduce_logging'] || false}, true)
      end

      if current_user.preferences.show_aggregate_result && !APP_CONFIG['use_opml_structure']
        agg_options = options.clone
        agg_options[:filters][:providers] = [Provider.root._id.to_s]
        aqr = QME::QualityReport.find_or_create(params[:measure_id],
                                           params[:sub_id], agg_options)
        if !aqr.calculated?
          aqr.calculate( {"oid_dictionary" =>OidHelper.generate_oid_dictionary(aqr.measure),
          "enable_rationale" => APP_CONFIG['enable_map_reduce_rationale'] || false,
          "enable_logging" => APP_CONFIG['enable_map_reduce_logging'] || false}, true)
        end
      end

      render json: qr
    end

    api :DELETE, '/queries/:id', "Remove clinical quality measure calculation"
    param :id, String, :desc => 'The id of the quality measure calculation', :required => true
    def destroy
      qr = QME::QualityReport.find(params[:id])
      authorize! :delete, qr
      qr.destroy
      render :status=> 204, :text=>""
    end

    api :PUT, '/queries/:id/recalculate', "Force a clinical quality measure to recalculate"
    param :id, String, :desc => 'The id of the quality measure calculation', :required => true
    def recalculate
      qr = QME::QualityReport.find(params[:id])
      authorize! :recalculate , qr
      qr.calculate({"oid_dictionary" =>OidHelper.generate_oid_dictionary(qr.measure_id),
                     'recalculate' =>true}, true)
      render json: qr
    end

    api :GET, '/queries/:id/patient_results[?population=true|false]',
              "Retrieve patients relevant to a clinical quality measure calculation"
    param :id, String, :desc => 'The id of the quality measure calculation', :required => true
    param :ipp, /true|false/, :desc => 'Ensure patients meet the initial patient population for the measure', :required => false
    param :denom, /true|false/, :desc => 'Ensure patients meet the denominator for the measure', :required => false
    param :numer, /true|false/, :desc => 'Ensure patients meet the numerator for the measure', :required => false
    param :denex, /true|false/, :desc => 'Ensure patients meet the denominator exclusions for the measure', :required => false
    param :denexcp, /true|false/, :desc => 'Ensure patients meet the denominator exceptions for the measure', :required => false
    param :msrpopl, /true|false/, :desc => 'Ensure patients meet the measure population for the measure', :required => false
    param :antinumerator, /true|false/, :desc => 'Ensure patients are not in the numerator but are in the denominator for the measure', :required => false
    param_group :pagination, Api::PatientsController
    example '[{"_id":"52fe409ef78ba5bfd2c4127f","value":{"DENEX":0,"DENEXCEP":0,"DENOM":1,"IPP":1,"NUMER":1,"antinumerator":0,"birthdate":1276869600.0,"effective_date":1356998340.0,,"first":"Steve","gender":"M","last":"E","measure_id":"40280381-3D61-56A7-013E-6224E2AC25F3","medical_record_id":"ce83c561f62e245ad4e0ca648e9de0dd","nqf_id":"0038","patient_id":"52fbbf34b99cc8a728000068"}},...]'
    description <<-PRDESC
      This action returns an array of patients that have results calculated for this clinical quality measure. The list can be restricted
      to specific populations, such as only patients that have made it into the numerator by passing in a query parameter for a particular
      population. Results are paginated.
    PRDESC
    def patient_results
      qr = QME::QualityReport.find(params[:id])
      authorize! :read, qr
      # this returns a criteria object so we can filter it additionally as needed
#      results = qr.patient_results
      query = {'value.measure_id' => qr.measure_id, 'value.effective_date' => qr.effective_date, 'value.provider_performances.provider_id' => qr.filters[:providers].first}
      results = QME::PatientCache.where(query)
      render json: paginate(patient_results_api_query_url(qr),results.where(build_patient_filter).only('_id', 'value.medical_record_id', 'value.first', 'value.last', 'value.birthdate', 'value.gender', 'value.patient_id'))
    end

    def patients
      qr = QME::QualityReport.find(params[:id])
      authorize! :read, qr
      # this returns a criteria object so we can filter it additionally as needed
      results = qr.patient_results
      ids = paginate(patients_api_query_url(qr),results.where(build_patient_filter).order_by([:last.asc, :first.asc])).collect{|r| r["value.medical_record_id"]}
      render :json=> Record.where({:medical_record_number.in => ids})
    end


  private
    def build_filter
      @filter = params.select { |k, v| %w(providers).include? k }.to_options
    end

    def authorize_providers
      providers = @filter[:providers] || []
      if !providers.empty?
        providers.each do |p|
          provider = Provider.find(p)
          authorize! :read, provider
        end
      else
        #this is hacky and ugly but cancan will allow just the
        # class Provider to pass for a simple user so providing
        #an empty Provider with no NPI number gets around this
        authorize! :read, Provider.new
      end
    end

    def build_mr_prefilter
      measure = HealthDataStandards::CQM::Measure.where({"hqmf_id" => params[:measure_id], "sub_id"=>params[:sub_id]}).first
      measure.prefilter_query!(params[:effective_date].to_i)
    end

    def build_patient_filter
      patient_filter = {}
      patient_filter["value.IPP"]= {"$gt" => 0} if params[:ipp] == "true"
      
      if params[:denom] == "true"
        patient_filter["value.DENOM"]= {"$gt" => 0} 
        patient_filter["value.DENEX"] = 0
      end
      patient_filter["value.NUMER"]= {"$gt" => 0} if params[:numer] == "true"
      patient_filter["value.DENEX"]= {"$gt" => 0} if params[:denex] == "true"
      patient_filter["value.DENEXCEP"]= {"$gt" => 0} if params[:denexcep] == "true"
      patient_filter["value.MSRPOPL"]= {"$gt" => 0} if params[:msrpopl] == "true"
      patient_filter["value.antinumerator"]= {"$gt" => 0} if params[:antinumerator] == "true"
      patient_filter["value.provider_performances.provider_id"]= BSON::ObjectId.from_string(params[:provider_id]) if params[:provider_id]
      patient_filter
    end

    def collect_provider_id
      params[:providers] || Provider.where({:npi.in => params[:npis] || []}).to_a
    end
  end
end
