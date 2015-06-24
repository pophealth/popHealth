  module Api
  class PatientsController < ApplicationController
    resource_description do
      short 'Patients'
      description <<-PCDESC
        This resource allows for the management of patient records in the popHealth application.
        Patient records can be inserted into popHealth in QRDA Category I format through this resource.
        Additionally, patient information may be retrieved from popHealth. This includes popHealth's
        internal representation of a patient as well as results for clinical quality measure calculations
        for a particular patient.

        Ids used for patients by this resource are the MongoDB identifier for the patient, not the
        patient's medical record number.
      PCDESC
    end
    include PaginationHelper
    include ApplicationHelper
    respond_to :json
    before_filter :authenticate_user!
    before_filter :validate_authorization!
    before_filter :load_patient, :only => [:show, :delete, :toggle_excluded, :results]
    before_filter :set_pagination_params, :only => :index
    before_filter :set_filter_params, :only => :index

    def_param_group :pagination do
      param :page, /\d+/
      param :per_page, /\d+/
    end

    api :GET, "/patients", "Get a list of patients"
    param_group :pagination
    formats ['json']
    def index
      records = Record.where(@query)
      validate_record_authorizations(records)
      respond_with  paginate(api_patients_url,records)
    end

    api :GET, "/patients/:id[?include_results=:include_results]", "Retrieve an individual patient"
    formats ['json']
    param :id, String, :desc => "Patient ID", :required => true
    param :include_results, String, :desc => "Include measure calculation results", :required => false
    example '{"_id":"52fbbf34b99cc8a728000068","birthdate":1276869600,"first":"John","gender":"M","last":"Peters","encounters":[{...}], ...}'
    def show
      json_methods = [:language_names]
      json_methods << :cache_results if params[:include_results]
      json = @patient.as_json({methods: json_methods})
      provider_list = @patient.provider_performances.map{ |p| p.provider}
      provider_list.each do |prov|
        if prov
          if prov.leaf?
            json['provider_name'] = prov.given_name
          end
        end
      end
#      if results = json.delete('cache_results')
#        json['[measure_results'] = results_with_measure_metadata(results)
#      end
      Log.create(:username =>   current_user.username,
                 :event =>      'patient record viewed',
                 :medical_record_number => @patient.medical_record_number)
      render :json => json
    end

    api :POST, "/patients", "Load a patient into popHealth"
    formats ['xml']
    param :file, nil, :desc => "The QRDA Cat I file", :required => true
    param :practice_id, String, :desc => "ID for the patient's Practice", :required => false
    param :practice_name, String, :desc => "Name for the patient's Practice", :required => false
    description "Upload a QRDA Category I document for a patient into popHealth."
    def create
      authorize! :create, Record
      
      practice = get_practice_parameter(params[:practice_id], params[:practice_name])
      
      success = BulkRecordImporter.import(params[:file], {}, practice)
      if success
        Log.create(:username => @current_user.username, :event => 'record import')
        render status: 201, text: 'Patient Imported'
      else
        render status: 500, text: 'Patient record did not save properly'
      end
    end    

    def toggle_excluded
      # TODO - figure out security constraints around manual exclusions -- this should probably be built around
      # the security constraints for queries
      ManualExclusion.toggle!(@patient, params[:measure_id], params[:sub_id], params[:rationale], current_user)
      redirect_to :controller => :measures, :action => :patients, :id => params[:measure_id], :sub_id => params[:sub_id]
    end

    api :DELETE, '/records/:id', "Remove a patient from popHealth"
    param :id, String, :desc => 'The id of the patient', :required => true
    def destroy
      authorize! :delete, @patient
      @patient.destroy
      render :status=> 204, text=> ""
    end

    api :GET, "/patients/:id/results", "Retrieve the CQM calculation results for a individual patient"
    formats ['json']
    param :id, String, :desc => "Patient ID", :required => true
    example '[{"DENOM":1.0,"NUMER":1.0,"DENEXCEP":0.0,"DENEX":0.0",measure_id":"40280381-3D61-56A7-013E-6224E2AC25F3","nqf_id":"0038","effective_date":1356998340.0,"measure_title":"Childhood Immunization Status",...},...]'
    def results
      render :json=> results_with_measure_metadata(@patient.cache_results(params))
    end

    private

    def load_patient
      @patient = Record.find(params[:id])
      authorize! :read, @patient
    end

    def validate_authorization!
      authorize! :read, Record
    end

    def validate_record_authorizations(records)
      records.each do |record|
        authorize! :read, record
      end    
    end

    def set_filter_params
      @query = {}
      if params[:quality_report_id]
        @quality_report = QME::QualityReport.find(params[:quality_report_id])
        authorize! :read, @quality_report
        @query["provider.npi"] = {"$in" => @quality_report.filters["providers"]}
      elsif current_user.admin?
      else
         @query["provider.npi"] = current_user.npi
      end
      @order = params[:order] || [:last.asc, :first.asc]
    end

    def results_with_measure_metadata(results)
      results.to_a.map do |result|
        hqmf_id = result['value']['measure_id']
        sub_id = result['value']['sub_id']
        measure = HealthDataStandards::CQM::Measure.where("hqmf_id" => hqmf_id, "sub_id" => sub_id).only(:title, :subtitle, :name).first
        result['value'].merge(measure_title: measure.title, measure_subtitle: measure.subtitle)
      end
    end
  end
end
