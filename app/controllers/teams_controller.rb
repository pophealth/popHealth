class TeamsController < ApplicationController

  load_resource except: %w{index}
  authorize_resource
  before_filter :authenticate_user!
  
  def index
    @teams = Team.alphabetical
  end
  
  def new
    @team = Team.new
  end
  
  def edit
    
  end
  
  def create
    Team.create(params[:team])
    redirect_to :action => "index"
  end
  
  def update
    @team.update_attributes(params[:team])
    redirect_to :action => "index"
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