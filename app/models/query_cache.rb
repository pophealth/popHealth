class QueryCache
  include Mongoid::Document
  
  store_in collection: :query_cache
  
  field :measure_id, type: String
  field :sub_id, type: String
  
end
