class ProvidersController < ApplicationController
  
  before_filter :provider_list
  before_filter :get_provider, :except => :index
  
  def index
  end
  
  def show
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def edit
  end
  
  def update
    @provider.update_attributes!(params[:provider])
    render :action => "show"
  end
  
  def merge_list
   
  end
  
  def merge
   other_provider = Provider.find(params[:other_provider_id])
   @provider.merge_provider(other_provider)
   other_provider.destroy
   @provider.save!
   redirect_to :action => :show
  end
  
  private
  
  def provider_list
    @providers = Provider.alphabetical unless request.xhr?
  end
  
  def get_provider
    @provider = Provider.find(params[:id])
  end

end
