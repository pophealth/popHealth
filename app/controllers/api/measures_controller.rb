module Api
  class MeasuresController < ApplicationController
    include PaginationHelper
    before_filter :authenticate_user!
    before_filter :validate_authorization!
    before_filter :set_pagination_params, :only=> :index
    before_filter :create_filter , :only => :index
    
    def index
      measures = HealthDataStandards::CQM::Measure.where(@filter)
      render json: paginate(api_measures_url, measures), each_serializer: HealthDataStandards::CQM::MeasureSerializer
    end
    
    def show
      measure = HealthDataStandards::CQM::Measure.where({"hqmf_id" => params[:id], "sub_id"=>params[:sub_id]}).first
      render :json=> measure
    end
    
    def create
       authorize! :create, HealthDataStandards::CQM::Measure
    end

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