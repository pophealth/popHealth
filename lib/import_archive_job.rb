class ImportArchiveJob
  attr_accessor :file, :current_user

  def initialize(options)
    @file = options['file'].path
    @current_user = options['user']
  end

  def before
    Log.create(:username => @current_user.username, :event => 'record import')
  end

  def perform
    missing_patients = HealthDataStandards::Import::BulkRecordImporter.import_archive(File.new(@file))
    missing_patients.each do |id|
      Log.create(:username => @current_user.username, :event => "patient id '#{id}' was present in patient manifest but not found after import")
    end
  end

  def after
    File.delete(@file)
  end
end
