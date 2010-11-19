require 'mongo'

if ENV['MONGOHQ_URL']
  uri = URI.parse(ENV['MONGOHQ_URL'])
  conn = Mongo::Connection.new(uri.host, uri.port)
  MONGO_DB = conn.db(uri.path.gsub(/^\//, ''))
else
  MONGO_DB = Mongo::Connection.new('localhost', 27017).db('test')
end