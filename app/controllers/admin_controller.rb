require 'import_archive_job'
require 'fileutils'

class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!
  add_breadcrumb 'admin', :admin_users_path

  def patients
    @patient_count = Record.count
    @query_cache_count = QueryCache.count
    @patient_cache_count = PatientCache.count
    @provider_count = Provider.count
  end

  def remove_patients
    Record.delete_all
    redirect_to action: 'patients'
  end

  def remove_caches
    QueryCache.delete_all
    PatientCache.delete_all
    redirect_to action: 'patients'
  end

  def remove_providers
    Provider.delete_all
    redirect_to action: 'patients'
  end
  
  def upload_patients

    file = params[:file]

    FileUtils.mkdir_p(File.join(Dir.pwd, "tmp/import"))
    file_location = File.join(Dir.pwd, "tmp/import")
    file_name = "patient_upload" + Time.now.to_i.to_s + rand(1000).to_s

    temp_file = File.new(file_location + "/" + file_name, "w")

    File.open(temp_file.path, "wb") { |f| f.write(file.read) }

    Delayed::Job.enqueue ImportArchiveJob.new({'file' => temp_file,'user' => current_user})
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