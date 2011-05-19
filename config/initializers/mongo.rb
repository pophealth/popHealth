MONGO_DB = Mongoid.database

js_collection = MONGO_DB['system.js']

unless js_collection.find_one('_id' => 'contains')
  js_collection.save('_id' => 'contains', 
                     'value' => BSON::Code.new("function( obj, target ) { return obj.indexOf(target) != -1; };"))
end


module QME
  module DatabaseAccess
    # Monkey patch in the connection for the application
    def get_db
      MONGO_DB
    end
  end
end
