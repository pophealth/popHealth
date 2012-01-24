require 'record_importer'
require 'json'
namespace :import do

  desc 'import patient records'
  task :patients, [:source_dir, :providers_predefined] do |t, args|
    if !args.source_dir || args.source_dir.size==0
      raise "please specify a value for source_dir"
    end
    importer = RecordImporter.new(args.source_dir, args.providers_predefined == 'true')
    importer.run
  end

  desc 'import providers from a file containing a json array of providers'
  task :providers, [:provider_json] do |t, args|
    if !args.provider_json || args.provider_json.size==0
      raise "please specify a value for provider_json"
    end
    
    providers = JSON.parse(File.new(args.provider_json).read)
    providers.each {|provider_hash| Provider.new(provider_hash).save}
    puts "imported #{providers.count} providers"
  end

end