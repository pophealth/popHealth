class ProvidersController < ApplicationController
  
  # load resource must be before authorize resource
  load_resource except: %w{index}
  authorize_resource
  before_filter :authenticate_user!
  before_filter :provider_list, except: 'measure'
  
  add_breadcrumb 'providers', :providers_url
  
  def index
    @providers = Provider.alphabetical.paginate(page: params[:page], per_page: 20)
    
    respond_to do |wants|
      wants.json { render json: @providers.to_json(:only => [:title, :given_name, :family_name, :npi]) }
    end
  end
  
  def show
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def edit
    render partial: 'edit_profile'    
  end
  
  def update
    @provider.update_attributes!(params[:provider])
    render :action => "show"
  end
  
  def merge_list
    render partial: 'merge_form'
  end
  
  def merge
   other_provider = Provider.find(params[:other_provider_id])
   @provider.merge_provider(other_provider)
   other_provider.destroy
   @provider.save!
   redirect_to :action => :show
  end
  
  def measure
    @selected_providers = Provider.selected_or_all(params[:selected_provider_ids]).alphabetical
    @selected_races = (params[:selected_race_ids] && !params[:selected_race_ids].empty?) ? Race.selected(params[:selected_race_ids]).ordered : []
    @selected_genders = (params[:selected_genders] && !params[:selected_genders].empty?) ? params[:selected_genders] : []
    @definition = QME::QualityMeasure.new(params[:measure_id], params[:sub_id]).definition
    calculate_measure_for_selected(@definition["id"], @definition['sub_id'], providers: @selected_providers, races: @selected_races, genders: @selected_genders)
    respond_to do |wants|
      wants.html do 
        @teams = Team.alphabetical
        @races = Race.ordered
        @genders = [{name: 'Male', key: 'M'}, {name: 'Female', key: 'F'}]
      end

      wants.json do
        complete = @provider_job_uuids.empty? && @aggregate_quality_report_uuid.nil?
        render json: {aggregate: @aggregate_quality_report.result, providers: @provider_reports, aggregate_job: @aggregate_quality_report_uuid, provider_jobs: @provider_job_uuids, :complete => complete}.to_json
      end
    end
  end
  
  private
  
  def provider_list
    @providers = Provider.alphabetical unless request.xhr?
  end

  def calculate_measure_for_selected(measure_id, sub_id, filters)
    @provider_job_uuids = {}
    @aggregate_quality_report = calculate_measure(measure_id, sub_id, filters)
    @aggregate_quality_report_uuid = @aggregate_quality_report.calculate unless @aggregate_quality_report.calculated?
    @provider_reports = {}
    filters[:providers].each do |provider| 
      provider_filters = filters.clone
      provider_filters[:providers] = [provider]
      report = calculate_measure(measure_id, sub_id, provider_filters)
      @provider_job_uuids[provider.id] = report.calculate unless report.calculated?
      @provider_reports[provider.id] = report.result
    end
  end
  
  def calculate_measure(measure_id, sub_id, filters)
    QME::QualityReport.new(measure_id, sub_id, 'effective_date' => @effective_date, 'filters' => {'providers' => filters[:providers].map { |pv| pv.id.to_s }, 'races'=>filters[:races].map {|value| value.flatten(:race)}.flatten, 'ethnicities'=>filters[:races].map {|value| value.flatten(:ethnicity)}.flatten, 'genders'=>filters[:genders]})
  end
  

end
