module Api
  class MeasuresController < ApplicationController
    resource_description do
      short 'Measures'
      formats ['json']
      description "This resource allows for the management of clinical quality measurses in the popHealth application."
    end
    include PaginationHelper
    before_filter :authenticate_user!
    before_filter :validate_authorization!
    before_filter :set_pagination_params, :only=> :index
    before_filter :create_filter , :only => :index
    
    api :GET, "/measures", "Get a list of measures"
    param_group :pagination, Api::PatientsController
    def index
      measures = HealthDataStandards::CQM::Measure.where(@filter)
      render json: paginate(api_measures_url, measures), each_serializer: HealthDataStandards::CQM::MeasureSerializer
    end
    
    api :GET, "/measures/:id", "Get an individual clinical quality measure"
    param :id, String, :desc => 'The HQMF id for the CQM to calculate', :required => true
    param :sub_id, String, :desc => 'The sub id for the CQM to calculate. This is popHealth specific.', :required => false
    def show
      measure = HealthDataStandards::CQM::Measure.where({"hqmf_id" => params[:id], "sub_id"=>params[:sub_id]}).first
      render :json=> measure
    end
    
    api :POST, "/measures", "Load a measure into popHealth"
    description "The uploaded measure must be in the popHealth JSON measure format. This will not accept HQMF definitions of measures."
    def create
       authorize! :create, HealthDataStandards::CQM::Measure
    end

    api :DELETE, '/measures/:id', "Remove a clinical quality measure from popHealth"
    param :id, String, :desc => 'The HQMF id for the CQM to calculate', :required => true
    description "Removes the measure from popHealth. It also removes any calculations for that measure."
    def destroy
      authorize! :delete, HealthDataStandards::CQM::Measure
      measure = HealthDataStandards::CQM::Measure.where({"hqmf_id" => params[:id]})
      #delete all of the pateint and query cache entries for the measure
      HealthDataStandards::CQM::PatientCache.where({"value.measure_id" => params[:id]}).destroy
      HealthDataStandards::CQM::QueryCache.where({"measure_id" => params[:id]}).destroy
      measure.destroy
      render :status=>204, :text=>""
    end

  private

    def validate_authorization!
      authorize! :read, HealthDataStandards::CQM::Measure
    end
    
    def create_filter
      measure_ids = params[:measure_ids]
      @filter = measure_ids.nil? || measure_ids.empty? ? {} : {:hqmf_id.in => measure_ids}
    end

  end
end