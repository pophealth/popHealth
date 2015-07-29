class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  authorize_resource
  # GET /teams
  def index
    @teams = @current_user.teams ? @current_user.teams.map{|id| Team.find(id)} : []
    validate_authorization!(@teams)
  end

  # GET /teams/1
  def show
    @providers = @team.providers.map do |id| 
      provider = Provider.find(id)
      provider unless cannot? :read, provider 
    end
  end

  # GET /teams/new
  def new
    if current_user.admin? || APP_CONFIG['use_opml_structure']
      @providers = Provider.all
    else
      @providers = Provider.where(parent_id: current_user.try(:practice).try(:provider_id))
    end
  end
  
  # POST 
  def create
    name = params[:name]
    provider_ids = params[:provider_ids]
    
    if name.strip.length > 0  && !provider_ids.blank?
      @team = Team.create(:name => params[:name])
      provider_ids.each do |prov_id|
        @team.providers << prov_id
      end
      @team.user_id = @current_user._id
      @team.save!
      
      if !current_user.teams
        current_user.teams = []
      end
      current_user.teams << @team.id
      current_user.save!
      redirect_to @team
    else
      redirect_to :action => :new
    end
  end
  
  def create_default
    if current_user.practice
      @team = Team.find_or_create_by(:name => "All Providers")
      @team.providers = []
      Provider.where(parent_id: current_user.practice.provider_id).each do |prov|
        @team.providers << prov.id.to_s
      end
      @team.user_id = current_user._id
      @team.save!
      if !current_user.teams
        current_user.teams = []
      end
      unless current_user.teams.include?(@team.id)
        current_user.teams << @team.id
      end
      current_user.save!
    end
    redirect_to :action => :index
  end

  # post /teams/1
  def update
    name = params[:name]
    provider_ids = params[:provider_ids]

    if name.strip.length > 0  && !provider_ids.blank?
      @team.name = name
      @team.providers.clear
      provider_ids.each do |prov_id|
        @team.providers << prov_id
      end
      @team.save!
    end
    
    redirect_to @team
  end

  # GET /teams/1/edit
  def edit
    if current_user.admin? || APP_CONFIG['use_opml_structure']
      @providers = Provider.all
    else
      @providers = Provider.where(parent_id: current_user.practice.provider_id)
    end      
  end

  # DELETE /teams/1
  def destroy
    tmp = @current_user.teams
    tmp.delete(@team.id)
    @current_user.teams = tmp
    @current_user.save!
    
    @team.destroy
    redirect_to teams_url, notice: 'Team was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
      validate_authorization!([@team])
    end
   
    def validate_authorization!(teams)
      teams.each do |team|
        authorize! :manage, team
      end
    end
end
