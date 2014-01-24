class ImportArchiveJob
  attr_accessor :file, :current_user

  def initialize(options)
    @file = options['file'].path
    @current_user = options['user']
  end

  def before
    Atna.log(@current_user.username, :phi_import)
  end

  def perform
    HealthDataStandards::Import::BulkRecordImporter.import_archive(File.new(@file))
  end

  def after
    File.delete(@file)
  end
end