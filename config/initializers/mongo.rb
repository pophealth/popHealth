require 'mongo'

if ENV['MONGOHQ_URL']
  uri = URI.parse(ENV['MONGOHQ_URL'])
  MONGO_CONNECTION = Mongo::Connection.new(uri.host, uri.port)
else
  MONGO_CONNECTION = Mongo::Connection.new('localhost', 27017)
end