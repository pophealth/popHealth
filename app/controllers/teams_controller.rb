class TeamsController < ApplicationController

  load_resource except: %w{index}
  authorize_resource
  before_filter :authenticate_user!
  before_filter :get_teams
  
  def index
  end
  
  def new
  end
  
  def edit
  end
  
  def create
    @team = Team.create(params[:team])

    respond_to do |wants|
      wants.html { redirect_to :action => "index" }
      wants.js { render partial: "update_form"}
    end
    
  end
  
  def update
    @team.update_attributes(params[:team])
    @teams = Team.alphabetical
    
    respond_to do |wants|
      wants.html { redirect_to :action => "index" }
      wants.js { render partial: "update_form"}
    end

  end
  
  def destroy
    @team.destroy
    
    respond_to do |wants|
      wants.html { redirect_to :action => "index" }
      wants.js { render partial: "update_form"}
    end
  end
  
  private

  def get_teams
    @teams = Team.alphabetical
  end

end