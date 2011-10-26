class ProvidersController < ApplicationController
  
  # load resource must be before authorize resource
  load_resource except: %w{index}
  authorize_resource
  before_filter :authenticate_user!
  before_filter :provider_list
  
  def index
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
    @teams = Team.alphabetical
    @selected_providers = {}
    Provider.alphabetical.each {|provider| @selected_providers[provider.id] = provider}
    @measure_id = params[:measure_id]
    @sub_id = params[:sub_id]
    calculate_measure_for_selected(@measure_id, @sub_id, @selected_providers)
    
  end
  
  private
  
  def provider_list
    @providers = Provider.alphabetical unless request.xhr?
  end

  def calculate_measure_for_selected(measure_id, sub_id, selected_providers)
    
    if current_user && current_user.effective_date
      @effective_date = current_user.effective_date
    else
      @effective_date = Time.gm(2010, 12, 31).to_i
    end

    @provider_ids = selected_providers.keys.map {|k| k.to_s}
    @provider_job_uuids = {}
    
    calculate_measure(measure_id, sub_id, @provider_ids)
    @provider_ids.each do |provider_id| 
      calculate_measure(measure_id, sub_id, [provider_id])
    end
  end
  
  def calculate_measure(measure_id, sub_id, provider_ids) 
    quality_report = QME::QualityReport.new(measure_id, sub_id, 'effective_date' => @effective_date, 'filters' => {'providers' => provider_ids})
    measure = QME::QualityMeasure.new(measure_id, sub_id)
    @provider_job_uuids[provider_ids] = quality_report.calculate unless quality_report.calculated?
  end
  

end
