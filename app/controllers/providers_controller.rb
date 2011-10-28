class ProvidersController < ApplicationController
  
  # load resource must be before authorize resource
  load_resource except: %w{index}
  authorize_resource
  before_filter :authenticate_user!
  before_filter :provider_list, except: 'measure'
  
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
    @definition = QME::QualityMeasure.new(params[:measure_id], params[:sub_id]).definition
    calculate_measure_for_selected(@definition["id"], @definition['sub_id'], @selected_providers)

    respond_to do |wants|
      wants.html do 
        @teams = Team.alphabetical
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

  def calculate_measure_for_selected(measure_id, sub_id, selected_providers)
    @provider_job_uuids = {}
    @aggregate_quality_report = calculate_measure(measure_id, sub_id, selected_providers)
    @aggregate_quality_report_uuid = @aggregate_quality_report.calculate unless @aggregate_quality_report.calculated?
    @provider_reports = {}
    selected_providers.each do |provider| 
      report = calculate_measure(measure_id, sub_id, [provider])
      @provider_job_uuids[provider.id] = report.calculate unless report.calculated?
      @provider_reports[provider.id] = report.result
    end
  end
  
  def calculate_measure(measure_id, sub_id, providers)
    QME::QualityReport.new(measure_id, sub_id, 'effective_date' => @effective_date, 'filters' => {'providers' => providers.map { |pv| pv.id.to_s }})
  end
  

end
