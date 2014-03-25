require 'json'
namespace :import do

  desc 'import patient records'
  task :patients, [:source_dir, :providers_predefined] do |t, args|
    if !args.source_dir || args.source_dir.size==0
      raise "please specify a value for source_dir"
    end
    HealthDataStandards::Import::BulkRecordImporter.import_directory(args.source_dir)
  end

end
