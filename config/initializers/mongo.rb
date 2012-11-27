MONGO_DB = Mongoid.default_session

# js_collection = MONGO_DB['system.js']

# unless js_collection.find_one('_id' => 'contains')
#   js_collection.save('_id' => 'contains', 
#                      'value' => BSON::Code.new("function( obj, target ) { return obj.indexOf(target) != -1; };"))
# end

# # create a unique index for patient cache, this prevents a race condition where the same patient can be entered multiple times for a patient
# MONGO_DB.collection('patient_cache').ensure_index([['value.measure_id', Mongo::ASCENDING], ['value.sub_id', Mongo::ASCENDING], ['value.effective_date', Mongo::ASCENDING], ['value.patient_id', Mongo::ASCENDING]], {'unique'=> true})

# base_fields = [['value.measure_id', Mongo::ASCENDING], ['value.sub_id', Mongo::ASCENDING], ['value.effective_date', Mongo::ASCENDING], ['value.test_id', Mongo::ASCENDING],  ['value.manual_exclusion', Mongo::ASCENDING]]

# %w(population denominator numerator antinumerator exclusions).each do |group|
#   MONGO_DB.collection('patient_cache').ensure_index(base_fields.clone.concat([["value.#{group}", Mongo::ASCENDING]]), {name: "#{group}_index"})
# end

module QME
  module DatabaseAccess
    # Monkey patch in the connection for the application
    def get_db
      MONGO_DB
    end
  end
end

# TODO Set indexes