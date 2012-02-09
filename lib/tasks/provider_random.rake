require 'mongo'
require 'json'
require 'factory_girl'

db_name = ENV['DB_NAME'] || 'test'

namespace :provider do

  desc 'Generate n (default 10) random provider records and save them in the database'
  task :random, :n, :only_new do |t, args|
    
    FactoryGirl.find_definitions
    
    n = args.n.to_i>0 ? args.n.to_i : 10
    only_new = args.only_new == 'true'
    
    providers = []
    n.times do
      providers << Factory(:provider)
    end
    
    providers = Provider.all unless only_new
    
    Record.all.each do |record|
      if (record.provider_performances.empty?)
        provider_performance = Factory.build(:provider_performance, provider_id: providers.sample.id) if record.provider_performances.empty?
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

  desc 'de-identify providers'
  task :deidentify do |t, args|
    
    
    npi = 1234567890
    counter = 0
    Provider.order_by([:npi, :asc]).each do |provider|
      puts "#{provider.npi} -> #{npi + counter} Dr. John Doe#{counter+1}"
      provider.npi = "#{npi + counter}"
      counter = counter + 1;
      provider.title = 'Dr.'
      provider.given_name = "John"
      provider.family_name = "Doe#{counter}"
      provider.tin = nil
      provider.specialty = nil
      provider.phone = nil
      #provider.organization
      provider.save!
    end
    
  end
    
end