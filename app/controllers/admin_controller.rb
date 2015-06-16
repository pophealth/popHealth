require 'import_archive_job'
require 'fileutils'

class AdminController < ApplicationController

  before_filter :authenticate_user!
  before_filter :validate_authorization!

  def patients
    @patient_count = Record.count
    @query_cache_count = HealthDataStandards::CQM::QueryCache.count
    @patient_cache_count = PatientCache.count
    @provider_count = Provider.ne('cda_identifiers.root' => "Organization").count
    @practice_count = Practice.count
    @practices = Practice.asc(:name).map {|org| [org.name, org.id]}
    
  	import_log = Log.where(:event => 'record import')
  	med_id = import_log.last.medical_record_number unless import_log.count == 0

    @last_upload_date = import_log.count > 0 ? import_log.last.created_at.in_time_zone('Eastern Time (US & Canada)').ctime : nil
	  rec = (@patient_count == 0) ? 0 : Record.where(:medical_record_number => med_id).last
    @last_practice_upload = import_log.count > 0 ? import_log.last.practice : ''
    @last_filename = import_log.count > 0 ? import_log.last.filename : ''
  end

  def user_profile
    @user = User.find(params[:id])
    @practices = Practice.asc(:name).map {|org| [org.name, org.id]}
    @practice_pvs = Provider.by_npi(@user.npi).map {|pv| [pv.parent.practice.name + " - " + pv.full_name, pv.id]}
  end

  def set_user_practice
    @user = User.find(params[:user])
    @user.practice = (params[:practice].present?) ? Practice.find(params[:practice]) : nil
    @user.save
    redirect_to action: 'user_profile', :id => params[:user]
  end

  def set_user_practice_provider
    @user = User.find(params[:user])
    @user.provider_id = (params[:provider].present?)? Provider.find(params[:provider]).id : nil
    @user.save
    redirect_to action: 'user_profile', :id => params[:user]
  end

  def remove_patients
    Record.delete_all
    redirect_to action: 'patients'
  end

  def remove_caches
    HealthDataStandards::CQM::QueryCache.delete_all
    PatientCache.delete_all
    Mongoid.default_session["rollup_buffer"].drop()
    Mongoid.default_session["delayed_backend_mongoid_jobs"].drop()
    redirect_to action: 'patients'
  end

  def remove_providers
    Provider.ne('cda_identifiers.root' => "Organization").delete
    
    Team.all.each do |team|
      team.providers = []
      team.save!
    end
    
    redirect_to action: 'patients'
  end

  def upload_patients

    file = params[:file]
    practice = params[:practice]
    filename = file.original_filename
    
    FileUtils.mkdir_p(File.join(Dir.pwd, "tmp/import"))
    file_location = File.join(Dir.pwd, "tmp/import")
    file_name = "patient_upload" + Time.now.to_i.to_s + rand(1000).to_s

    temp_file = File.new(file_location + "/" + file_name, "w")

    File.open(temp_file.path, "wb") { |f| f.write(file.read) }

    Delayed::Job.enqueue(ImportArchiveJob.new({'practice' => practice, 'file' => temp_file,'user' => current_user, 'filename' => filename}),:queue=>:patient_import)
    redirect_to action: 'patients'
  end

  def upload_providers

    file = params[:file]
    FileUtils.mkdir_p(File.join(Dir.pwd, "tmp/import"))
    file_location = File.join(Dir.pwd, "tmp/import")
    file_name = "provider_upload" + Time.now.to_i.to_s + rand(1000).to_s

    temp_file = File.new(file_location + "/" + file_name, "w")

    File.open(temp_file.path, "wb") { |f| f.write(file.read) }

    provider_tree = ProviderTreeImporter.new(File.open(temp_file))
    provider_tree.load_providers(provider_tree.sub_providers)

    redirect_to action: 'patients'
  end

  def users
    @users = User.all.ordered_by_username
    @practices = Practice.asc(:name).map {|org| [org.name, org.id]}
    unless APP_CONFIG['use_opml_structure']
      @practice_providers = Provider.ne('cda_identifiers.root' => "Organization").asc(:given_name).map {|pv| [pv.full_name, pv.id]}
    end
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

  def delete_user
    @user = User.find(params[:id])
    if User.count == 1
      redirect_to :action => :users, notice: "Cannot remove sole user"
    elsif @user.admin? 
      redirect_to :action => :users, notice: "Cannot remove administrator"
    else
      @user.destroy
      redirect_to :action => :users
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
