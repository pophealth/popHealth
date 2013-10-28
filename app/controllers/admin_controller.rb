require 'record_importer'
include Mongoid

class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  add_breadcrumb 'Admin', :admin_users_path

  def patients
    @patient_count = Record.all.count
    @query_cache_count = QueryCache.all.count
    @patient_cache_count = PatientCache.all.count
  	@provider_count = Provider.all.count
  	@records = Record.all
  end
  def remove_patients
    Record.all.delete
    redirect_to action: 'patients'
  end
  def remove_caches
    QueryCache.all.delete
    PatientCache.all.delete
    redirect_to action: 'patients'
  end
  def remove_providers
    Provider.destroy_all
    redirect_to action: 'patients'
  end
	
	def user_profile
		@user = User.by_id(params[:id])
		
	end

  def upload_patients

    file = params[:file]
    if file!=nil
		  temp_file = Tempfile.new("patient_upload")
		
		  File.open(temp_file.path, "wb") { |f| f.write(file.read) }
		  
		  Zip::ZipFile.open(temp_file.path) do |zipfile|
		    zipfile.entries.each do |entry|
		      next if entry.directory?
		      xml = zipfile.read(entry.name)
		      result = RecordImporter.import(xml)
		      
		      if (result[:status] == 'success') 
		        @record = result[:record]
		        QME::QualityReport.update_patient_results(@record.medical_record_number)
		        Atna.log(current_user.username, :phi_import)
		        Log.create(:username => current_user.username, :event => 'patient record imported', :medical_record_number => @record.medical_record_number)
		      end    
		    end
		  end
		end
  	redirect_to action: 'patients'
  end

  def users
    @users = User.all.ordered_by_username
  end

  def promote
    toggle_privilidges(params[:username], params[:role], :promote)
  end

  def demote
    toggle_privilidges(params[:username], params[:role], :demote)
  end

  def disable
    user = User.by_username(params[:username]);
    disabled = params[:disabled].to_i == 1
    if user
      user.update_attribute(:disabled, disabled)
      if (disabled)
        render :text => "<a href=\"#\" class=\"disable\" data-username=\"#{user.username}\">disabled</span>"
      else
        render :text => "<a href=\"#\" class=\"enable\" data-username=\"#{user.username}\">enabled</span>"
      end
    else
      render :text => "User not found"
    end
  end

  def approve
    user = User.where(:username => params[:username]).first
    if user
      user.update_attribute(:approved, true)
      render :text => "true"
    else
      render :text => "User not found"
    end
  end

  def update_npi
    user = User.by_username(params[:username]);
    user.update_attribute(:npi, params[:npi]);
    render :text => "true"
  end
  
  # added from bstrezze !--
  def edit_teams
    @user = User.by_id(params[:id])

    # Add item
    if (params[:add_team] && params[:add_team][:team_id])
      if (!@user.teams)
        @user.teams = Array.new
      end
      
    unless (params[:add_team][:team_id] == '')
		    if @user.teams.include?(Moped::BSON::ObjectId(params[:add_team][:team_id]))
		      flash[:notice] = 'Selected team has already been added.'
		    #  redirect_to :back, :notice => 'Selected team has already been added.'
			    redirect_to :back 
		    else
		      @user.teams << Moped::BSON::ObjectId(params[:add_team][:team_id])
		      @user.save
		      redirect_to :back
		    end
		  end
    end

    # Remove item
    if (params[:remove_team] && params[:remove_team][:team_id])
      @user.teams.delete_if {|item| item == Moped::BSON::ObjectId(params[:remove_team][:team_id]) }
      @user.save
    end
    
  end
  # --!  

  # added by ssiddiqui for button
  def delete_user
  	@user = User.by_id(params[:id])
  	if(User.count == 1)
			#render :text => "Cannot remove sole user. Please go back"
			redirect_to :back, notice: "Cannot remove sole user"
  	else
  		if(@user.admin?)
  			#render :text => "Cannot remove administrator. Please go back"
  			redirect_to :back, notice: "Cannot remove administrator"
  		else
  			@user.destroy
  			redirect_to(:back)
  		end
  	end  
  end

  private

  def toggle_privilidges(username, role, direction)
    user = User.by_username username

    if user
      if direction == :promote
        user.update_attribute(role, true)
        render :text => "Yes - <a href=\"#\" class=\"demote\" data-role=\"#{role}\" data-username=\"#{username}\">revoke</a>"
      else
        user.update_attribute(role, false)
        render :text => "No - <a href=\"#\" class=\"promote\" data-role=\"#{role}\" data-username=\"#{username}\">grant</a>"
      end
    else
      render :text => "User not found"
    end
  end
  
  def validate_authorization!
    authorize! :admin, :users
  end
end
