module Api
  class QueriesController  < ApplicationController
    include PaginationHelper
    skip_authorization_check :only=> :create
    before_filter :authenticate_user!
    before_filter :set_pagination_params, :only=>[:patient_results, :patients]
   
    def index
      filter = {}
      filter["hqmf_id"] = {"$in" => params["measure_ids"]} if params["measure_ids"]
      providers = collect_provider_id
      filter["filters.providers"] = {"$in" => providers} if providers
      render json: QME::QualityReport.where(filter)
    end

    def show
      @qr = QME::QualityReport.find(params[:id])
      authorize! :read, @qr
      render json: @qr
    end

    def create
      build_filter
      authorize_providers
      qr = QME::QualityReport.find_or_create(params[:measure_id],
                                           params[:sub_id],
                                           {:effective_date=>params[:effective_date], :filters=>build_filter})
      if !qr.calculated?
        qr.calculate({"oid_dictionary" =>OidHelper.generate_oid_dictionary(qr.measure)}, true)
      end

      render json: qr
    end

    def destroy
      qr = QME::QualityReport.find(params[:id])
      authorize! :delete, qr
      qr.destroy
      render :status=> 204, :text=>""
    end

    def recalculate
      qr = QME::QualityReport.find(params[:id])
      authorize! :recalculate , qr
      qr.calculate({"oid_dictionary" =>OidHelper.generate_oid_dictionary(qr.measure_id),
                     'recalculate' =>true}, true)
      render json: qr
    end

    def patient_results
      qr = QME::QualityReport.find(params[:id])
      authorize! :read, qr
      # this returns a criteria object so we can filter it additionally as needed 
      results = qr.patient_results
      render json: paginate(patient_results_api_query_url(qr),results.where(build_patient_filter).order_by([:last.asc, :first.asc]))
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
      @filter = params[:filter] || {}
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

    def build_patient_filter
      patient_filter = {}
      patient_filter["value.IPP"]= {"$gt" => 0} if params[:ipp] == "true"
      patient_filter["value.DENOM"]= {"$gt" => 0} if params[:denom] == "true"
      patient_filter["value.NUMER"]= {"$gt" => 0} if params[:numer] == "true"
      patient_filter["value.DENEX"]= {"$gt" => 0} if params[:denex] == "true"
      patient_filter["value.DENEXCEP"]= {"$gt" => 0} if params[:denexcep] == "true"
      patient_filter["value.MSRPOPL"]= {"$gt" => 0} if params[:msrpopl] == "true"
      patient_filter["value.antinumerator"]= {"$gt" => 0} if params[:antinumerator] == "true"
      patient_filter
    end

    def collect_provider_id
      params[:providers] || Provider.where({:npi.in => params[:npis]}).to_a
    end
  end
end