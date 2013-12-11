  module Api
  class PatientsController < ApplicationController
    include PaginationHelper
    respond_to :json
    before_filter :authenticate_user!
    before_filter :validate_authorization!
    before_filter :load_patient, :only => [:show, :delete, :toggle_excluded, :results]
    before_filter :set_pagination_params, :only => :index
    before_filter :set_filter_params, :only => :index

    def index
      records = Record.where(@query)
      respond_with  paginate(api_patients_url,records)
    end

    def show
      respond_with @patient
    end

    def create
      authorize! :create, Record
      RecordImporter.import(params[:file])
    end

    def load
      authorize! :create, Record
      RecordImporter.load_zip(params[:file])
    end

    def destroy
      authorize! :delete, @patient
      respond_with({}, :status=>204)
    end

    
    def toggle_excluded
      # TODO - figure out security constraints around manual exclusions -- this should probably be built around
      # the security constraints for queries
      ManualExclusion.toggle!(@patient, params[:measure_id], params[:sub_id], params[:rationale], current_user)
      redirect_to :controller => :measures, :action => :patients, :id => params[:measure_id], :sub_id => params[:sub_id]
    end
    

    def destroy
      authorize! :delete, @patient
      @patient.destroy
      render :status=> 204, text=> ""
    end

    def results
      render :json=> @patient.cache_results(params).to_a
    end
    
    private
    
    def load_patient
      @patient = Record.find(params[:id])
      authorize! :read, @patient
    end

    def validate_authorization!
      authorize! :read, Record
    end

    def set_filter_params
      @query = {}
      if params[:quality_report_id]
        @quality_report = QME::QualityReport.find(params[:quality_report_id])
        authorize! :read, @quality_report
        @query["provider.npi"] = {"$in" => @quality_report.filters["providers"]}
      elsif current_user.is_admin?
      else
         @query["provider.npi"] = current_user.npi
      end
      @order = params[:order] || [:last.acsd, :first.asc]
    end

  end
end