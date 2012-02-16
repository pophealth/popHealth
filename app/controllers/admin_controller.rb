require 'record_importer'
class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  add_breadcrumb 'admin', :admin_users_path

  def patients
    @patient_count = Record.all.count
    @query_cache_count = QueryCache.all.count
    @patient_cache_count = PatientCache.all.count
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
  
  def upload_patients

    file = params[:file]
    i = 0
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
    user = User.first(:conditions => {:username => params[:username]})
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