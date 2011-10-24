class TeamsController < ApplicationController
  before_filter :find_model, :only => [:update, :destroy]
  
  def index
    @team = Team.alphabetical
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
    @team.update_attributess(params[:team])
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