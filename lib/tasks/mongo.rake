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
    # Re-init races and ethnicities
    MONGO_DB['races'].drop() if MONGO_DB['races']
    JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'races.json'))).each do |document|
      MONGO_DB['races'].insert(document)
    end

    MONGO_DB['ethnicities'].drop() if MONGO_DB['ethnicities']
    JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'ethnicities.json'))).each do |document|
      MONGO_DB['ethnicities'].insert(document)
    end

    # Additionally add languages if not found
    if MONGO_DB['languages'].find.count == 0
      JSON.parse(File.read(File.join(Rails.root, 'test', 'fixtures', 'code_sets', 'languages.json'))).each do |document|
        MONGO_DB['languages'].insert(document)
      end
    end
  end
end