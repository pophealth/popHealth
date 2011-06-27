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

end