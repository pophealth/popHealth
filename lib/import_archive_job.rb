class ImportArchiveJob
  attr_accessor :file, :current_user, :practice, :filename
  
  def initialize(options)
    @file = options['file'].path
    @current_user = options['user']
    @practice = options['practice']
    @filename = options['filename']
  end

  def before
    practice = @practice ? Practice.find(@practice).name : nil
      
    Log.create(:username => @current_user.username, :event => 'record import', :practice => practice, :filename => @filename)
  end

  def perform
    missing_patients = BulkRecordImporter.import_archive(File.new(@file), nil, @practice)
    missing_patients.each do |id|
      Log.create(:username => @current_user.username, :event => "patient was present in patient manifest but not found after import", :medical_record_number => id)
    end
  end

  def after
    File.delete(@file)
    HealthDataStandards::CQM::QueryCache.delete_all
    PatientCache.delete_all
    Mongoid.default_session["rollup_buffer"].drop()
    Mongoid.default_session["delayed_backend_mongoid_jobs"].drop()  
  end
end
