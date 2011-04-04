require 'mongo'

host = ENV['TEST_DB_HOST'] || 'localhost'
conn = Mongo::Connection.new(host, 27017)

MONGO_DB = conn["pophealth-#{Rails.env}"]

js_collection = MONGO_DB['system.js']

unless js_collection.find_one('_id' => 'contains')
  js_collection.save('_id' => 'contains', 
                     'value' => BSON::Code.new("function( obj, target ) { return obj.indexOf(target) != -1; };"))
end

