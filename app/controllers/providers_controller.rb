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
  
  def measures
    @teams = Team.alphabetical
    @categories = Measure.non_core_measures
    @core_measures = Measure.core_measures
    @core_alt_measures = Measure.core_alternate_measures
  end
  
  private
  
  def provider_list
    @providers = Provider.alphabetical unless request.xhr?
  end

end
