require 'mongo'
require 'json'

provider_template_dir = ENV['PROVIDER_TEMPLATE_DIR'] || File.join('fixtures', 'patient_templates')
db_name = ENV['DB_NAME'] || 'test'
loader = QME::Database::Loader.new(db_name)

namespace :provider do

  desc 'Generate n (default 10) random provider records and save them in the database'
  task :random, [:n] => ['mongo:drop_records'] do |t, args|
    n = args.n.to_i>0 ? args.n.to_i : 10
    
    templates = []
    Dir.glob(File.join(patient_template_dir, '*.json.erb')).each do |file|
      templates << File.read(file)
    end
    
    if templates.length<1
      puts "No provider templates in #{provider_template_dir}"
      return
    end
    
    n.times do
      
    end
  end
    
end