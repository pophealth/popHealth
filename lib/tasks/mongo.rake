namespace :db do

  namespace :test do
    task :prepare do
      # Stub out for MongoDB
    end
  end

  task :clear_cache => :environment do
    MONGO_DB.collection_names.find_all {|cn| cn.include?('cache')}.each do |collection_name|
      MONGO_DB[collection_name].drop
    end
  end
  
  task :load_race_and_ethnicity do
    MONGO_DB['races'].drop
    fixture_json = JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'raceandethnicity.json')))
    fixture_json.each do |document|
      MONGO_DB['races'].save(document)
    end
  end
end