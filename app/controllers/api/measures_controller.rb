require 'measures/loader.rb'
require 'hds/measure.rb'
module Api
  class MeasuresController < ApplicationController
    resource_description do
      short 'Measures'
      formats ['json']
      description "This resource allows for the management of clinical quality measures in the popHealth application."
    end
    include PaginationHelper
    before_filter :authenticate_user!
    before_filter :validate_authorization!
    before_filter :set_pagination_params, :only=> :index
    before_filter :create_filter , :only => :index
    before_filter :update_metadata_params, :only => :update_metadata

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
      measure_details = {
        'type'=>params[:measure_type],
        'episode_of_care'=>params[:calculation_type] == 'episode',
        'category'=> params[:category].empty? ?  "miscellaneous" : params[:category],
        'lower_is_better'=> params[:lower_is_better]
      }
      ret_value = {}
      hqmf_document = Measures::Loader.parse_model(params[:measure_file].tempfile.path)
      if measure_details["episode_of_care"]
        Measures::Loader.save_for_finalization(hqmf_document)
        ret_value= {episode_ids: hqmf_document.specific_occurrence_source_data_criteria().collect{|dc| {id: dc.id, description: dc.description}},
                    hqmf_id: hqmf_document.hqmf_id,
                    vsac_username: params[:vsac_username],
                    vsac_password: params[:vsac_password],
                    category: measure_details["category"],
                    lower_is_better: measure_details[:lower_is_better],
                    hqmf_document: hqmf_document
                  }
      else
        Measures::Loader.generate_measures(hqmf_document,params[:vsac_username],params[:vsac_password],measure_details)
      end
      render json: ret_value
      rescue => e
        render text: e.to_s, status: 500
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


    def update_metadata
      authorize! :update, HealthDataStandards::CQM::Measure
      measures = HealthDataStandards::CQM::Measure.where({ hqmf_id: params[:hqmf_id]})
      measures.each do |m|
        m.update_attributes(params[:measure])
        m.save
      end
      render json:  measures,  each_serializer: HealthDataStandards::CQM::MeasureSerializer
      rescue => e
        render text: e.to_s, status: 500
    end


    def finalize
      measure_details = {
          'episode_ids'=>params[:episode_ids],
          'category' => params[:category],
          'measure_type' => params[:measure_type],
          'lower_is_better' => params[:lower_is_better]

       }
      Measures::Loader.finalize_measure(params[:hqmf_id],params[:vsac_username],params[:vsac_password],measure_details)
      measure = HealthDataStandards::CQM::Measure.where({hqmf_id: params[:hqmf_id]}).first
      render json: measure, serializer: HealthDataStandards::CQM::MeasureSerializer
      rescue => e
        render text: e.to_s, status: 500
    end

  private

    def validate_authorization!
      authorize! :read, HealthDataStandards::CQM::Measure
    end

    def create_filter
      measure_ids = params[:measure_ids]
      @filter = measure_ids.nil? || measure_ids.empty? ? {} : {:hqmf_id.in => measure_ids}
    end

    def update_metadata_params
      params[:measure][:lower_is_better] = nil if params[:measure][:lower_is_better].blank?
    end

  end
end
