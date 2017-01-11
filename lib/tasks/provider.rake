# require 'mongo'
require 'json'
require 'factory_girl'
require "#{Rails.root}/app/helpers/reports_helper"
include ReportsHelper


db_name = ENV['DB_NAME'] || 'test'

namespace :provider do

  desc 'Generate n (default 10) random provider records and save them in the database'
  task :random, :n do |t, args|

    FactoryGirl.find_definitions

    n = args.n.to_i>0 ? args.n.to_i : 10

    FactoryGirl.create_list(:provider, n)

    providers = Provider.all

    Record.all.each do |record|
      if (record.provider_performances.empty?)
        provider_performance = Factory.build(:provider_performance, provider_id: Provider.all.sample.id) if record.provider_performances.empty?
        record.provider_performances << provider_performance
      end
    end
  end

  desc 'Dump all providers and provider performance information'
  task :destroy_all do |t, args|

    Record.all.each do |record|
      record.provider_performances = [] unless record.provider_performances.empty?
      record.save!
    end

    Provider.all.each { |pr| pr.destroy }

  end

  desc 'Load provider tree from OPML'
  task :load_from_opml, :path do |t, args|
    provider_tree = ProviderTreeImporter.new(File.new(args.path))
    provider_tree.load_providers(provider_tree.sub_providers)
  end

  desc 'import providers from a file containing a json array of providers'
  task :load_from_json, [:provider_json] do |t, args|
    if !args.provider_json || args.provider_json.size==0
      raise "please specify a value for provider_json"
    end

    providers = JSON.parse(File.new(args.provider_json).read)
    providers.each {|provider_hash| Provider.new(provider_hash).save}
    puts "imported #{providers.count} providers"
  end

  desc 'import practices and providers from a file containing a json array'
  task :load_practices_and_providers, [:import_json] do |t, args|
    if !args.import_json || args.import_json.size==0
      raise "please specify a value for import_json"
    end

    records = JSON.parse(File.new(args.import_json).read)
    records.each do |record_hash|
      if record_hash.has_key?('type') && record_hash['type'] == 'organization'
        save_practice_from_hash record_hash
      else
        provider = Provider.new(record_hash)
        provider.save!

        # If the parent wasn't set, but the organization is, we will associate the provider
        # with the organization record.  This is going to assume the organization was already
        # created/exists.
        if (record_hash['parent_id'].nil? && !record_hash['organization'].nil?)
          practice = Practice.where("name" => record_hash['organization']['name']).first
          unless (practice.nil?)
            provider.parent = practice.provider
            provider.save!
          end
        end
      end
    end
    puts "imported #{records.count} providers"
  end

  desc 'Export CAT3 XML for Provider'
  task :export_cat3, :root, :extension, :effective_date, :measure_ids do |t, args|
    provider = nil;
    if !args.root && args.extension
      # This is the root provider case
      provider = Provider.root
    end
    provider ||= Provider.where("cda_identifiers.root" => args.root, "cda_identifiers.extension" => args.extension).first
    puts generate_cat3(provider, args.effective_date, (args.measure_ids||"all").split(" "))

  end
end


def save_practice_from_hash(record_hash)
  practice = Practice.new({"name" => record_hash['name'], "organization" => record_hash['organization']})
  identifier = CDAIdentifier.new(:root => "Organization", :extension => record_hash['organization'])
  provider = Provider.new(:given_name => record_hash['name'])
  provider.cda_identifiers << identifier
  provider.parent = Provider.root
  provider.save!
  practice.provider = provider
  practice.save!
end