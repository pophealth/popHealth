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
  
  desc 'change patient names'
  task :rename_patients do |t, args|
    
    Record.all.each do |record|
      
      record.last = "#{record.last}-#{"%04d" % rand(9999)}"
      
      record.save!
    end
    
  end

  desc 'back fill patient cache'
  task :backfill_patient_cache do |t, args|

   caches = QueryCache.where({test_id:nil})

   randomizer = QME::Randomizer::Patient::Context.new
   
   counter = 1
   
   top_level = {}
   by_provider = {}
   
   caches.each do |cache| 
     measure_id = cache.measure_id + (cache.sub_id.nil? ? "" : cache.sub_id)
     if cache.filters == nil
       top_level[measure_id] = cache 
     else
       provider_id = cache.filters['providers'].first
       by_provider[provider_id] ||= {}
       by_provider[provider_id][measure_id] = cache
     end
   end
   
   measure_ids = top_level.keys
   provider_ids = by_provider.keys
   
   measure_ids.each do |measure_id|
     patient_cache_for_measure = {}
     puts "building top level #{measure_id}"
     cache = top_level[measure_id]
     denominator = cache.denominator
     patient_cache_for_measure[:numerator] ||= []
     patient_cache_for_measure[:denominator] ||= []
     
     (0...denominator).each do |index|
       
       numerator = index < cache.numerator
       
       gender = randomizer.gender
       race_and_ethnicity = randomizer.race_and_ethnicity
       language = randomizer.language
       
       patient_cache_base = {"value"=>{ 
            "measure_id" => measure_id,
            "numerator" => numerator,
            "antinumerator" => !numerator,
            "population" => true,
            "denominator" => true,
            "exclusions" => false,
            "patient_id" => BSON::ObjectId.new,
            "test_id" => nil,
            "effective_date" => 1325394000,
            "medical_record_id" => "#{11111111111+counter}",
            "first" => randomizer.forename(gender),
            "last" => "#{randomizer.surname}-#{"%04d" % rand(9999)}",
            "gender" => gender,
            "birthdate" => 97995600,
            "race" => { "code" => race_and_ethnicity[:race], "code_set" => "CDC-RE" },
            "ethnicity" => { "code" => race_and_ethnicity[:ethnicity], "code_set" => "CDC-RE" },
            "languages" => [ language ],
            "provider_performances"=>[]
       }}
       
       if (numerator) 
         patient_cache_for_measure[:numerator] << patient_cache_base
       else
         patient_cache_for_measure[:denominator] << patient_cache_base
       end
       
     end

     puts "filling providers #{measure_id}"
     provider_ids.each do |provider_id|
       cache = by_provider[provider_id][measure_id]
       
       patient_cache_for_measure[:numerator].sample(cache.numerator).each do |entry|
         entry['value']['provider_performances'] << { "provider_id" => BSON::ObjectId(provider_id), "start_date" => 256962454 } 
       end

       patient_cache_for_measure[:denominator].sample(cache.denominator - cache.numerator).each do |entry|
         entry['value']['provider_performances'] << { "provider_id" => BSON::ObjectId(provider_id), "start_date" => 256962454 } 
       end
       
     end
   
     puts "inserting #{measure_id}"
     patient_cache_for_measure[:numerator].each do |entry|
       MONGO_DB['patient_cache'] << entry
     end
     patient_cache_for_measure[:denominator].each do |entry|
       MONGO_DB['patient_cache'] << entry
     end
   end
    
  end
  
end