class ProvidersController < ApplicationController
  
  # load resource must be before authorize resource
  load_resource except: %w{index}
  authorize_resource
  before_filter :authenticate_user!
  
  add_breadcrumb 'providers', :providers_url
  
  def index
    @providers = Provider.alphabetical.page(params[:page]).per(20)
    
    respond_to do |wants|
      wants.html {}
      wants.js {}
      wants.json { render json: @providers.to_json(:only => [:title, :given_name, :family_name, :npi]) }
    end
  end
  
  def show
    respond_to do |wants|
      wants.html
      wants.js
    end
  end
  
  def new
    @provider = Provider.new
    respond_to do |wants|
      wants.js {}
    end
  end
  
  def edit
    @provider = Provider.find(params[:id])
    respond_to do |wants|
      wants.js {}
    end    
  end
  
  def create
    @provider = Provider.create(params[:provider])
    @providers = Provider.alphabetical.page(params[:page]).per(20)

    respond_to do |wants|
      wants.json {
        # @provider = Provider.create(params[:data])
        render json: @provider
      }
      wants.js { }
      wants.html { }
    end
  end
  
  def update
    @provider.update_attributes!(params[:provider])
    
    respond_to do |wants|
      wants.html { render :action => "show" }
      wants.js { @providers = Provider.alphabetical.page(params[:page]).per(20) }
    end
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

end