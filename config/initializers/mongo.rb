require 'mongo'

if ENV['MONGOHQ_URL']
  uri = URI.parse(ENV['MONGOHQ_URL'])
  conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
  MONGO_DB = conn.db(uri.path.gsub(/^\//, ''))
elsif ENV['TEST_DB_HOST']
  MONGO_DB = Mongo::Connection.new(ENV['TEST_DB_HOST'], 27017).db("pophealth-#{Rails.env}")
else
  MONGO_DB = Mongo::Connection.new('localhost', 27017).db("pophealth-#{Rails.env}")
end

QME::MongoHelpers.initialize_javascript_frameworks(MONGO_DB)
