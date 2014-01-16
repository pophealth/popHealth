class ImportArchiveJob
  attr_accessor :file, :current_user

  def initialize(options)
    @file = options['file'].path
    @current_user = options['user']._id
  end

  def perform
    RecordImporter.import_archive(File.new(@file), User.find(@current_user))
  end

  def after
    File.delete(@file)
  end
end