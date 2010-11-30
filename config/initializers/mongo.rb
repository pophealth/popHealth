require 'mongo'

if ENV['MONGOHQ_URL']
  uri = URI.parse(ENV['MONGOHQ_URL'])
  conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
  MONGO_DB = conn.db(uri.path.gsub(/^\//, ''))
else
  MONGO_DB = Mongo::Connection.new('localhost', 27017).db('test')
end

QME::MongoHelpers.initialize_javascript_frameworks(MONGO_DB)