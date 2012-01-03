MONGO_DB = Mongoid.database

js_collection = MONGO_DB['system.js']

unless js_collection.find_one('_id' => 'contains')
  js_collection.save('_id' => 'contains', 
                     'value' => BSON::Code.new("function( obj, target ) { return obj.indexOf(target) != -1; };"))
end

# create a unique index for patient cache, this prevents a race condition where the same patient can be entered multiple times for a patient
MONGO_DB.collection('patient_cache').ensure_index([['value.measure_id', Mongo::ASCENDING], ['value.sub_id', Mongo::ASCENDING], ['value.effective_date', Mongo::ASCENDING], ['value.patient_id', Mongo::ASCENDING]], {'unique'=> true})

base_fields = [['value.measure_id', Mongo::ASCENDING], ['value.sub_id', Mongo::ASCENDING], ['value.effective_date', Mongo::ASCENDING], ['value.test_id', Mongo::ASCENDING],  ['value.manual_exclusion', Mongo::ASCENDING]]

# create indexes for patient cache to boost performance
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.denominator', Mongo::ASCENDING], {name: 'denominator'})
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.numerator', Mongo::ASCENDING], {name: 'numerator'})
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.exclusions', Mongo::ASCENDING], {name: 'exclusions'})
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.antinumerator', Mongo::ASCENDING], {name: 'antinumerator'})

MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.gender', Mongo::ASCENDING], {name: 'gender'})
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.provider_performances.provider_id', Mongo::ASCENDING], {name: 'providers'})
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.race', Mongo::ASCENDING], {name: 'race'})
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.ethnicity', Mongo::ASCENDING], {name: 'ethnicity'})
MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone << ['value.languages', Mongo::ASCENDING], {name: 'language'})

module QME
  module DatabaseAccess
    # Monkey patch in the connection for the application
    def get_db
      MONGO_DB
    end
  end
end

