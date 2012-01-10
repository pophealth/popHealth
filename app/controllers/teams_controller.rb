class TeamsController < ApplicationController

  load_resource except: %w{index}
  authorize_resource
  before_filter :authenticate_user!
  
  def index
    @teams = Team.alphabetical
  end
  
  def new
    @team = Team.new
    @providers = Provider.alphabetical
  end
  
  def edit
    @providers = Provider.alphabetical
  end
  
  def create
    @team = Team.create(params[:team])
    if params[:provider_ids]
      @providers = Provider.find(params[:provider_ids])
      @team.providers.concat(@providers)
    end
    
    redirect_to :action => "index"
  end
  
  def update
    @team.update_attributes(params[:team])
    if params[:provider_ids]
       providers = Provider.find(params[:provider_ids])
      @team.providers.concat providers
    end
    @team.save
    redirect_to :action => "edit"
  end
  
  def destroy
    @team.destroy
    redirect_to :action => "index"
  end

  

  private
  
  def find_model
    @team = Team.find(params[:id])
  end
end