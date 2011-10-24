class ProviderPerformance
  include Mongoid::Document
  
  field :start_date, Integer
  field :end_date, Integer
  
  belongs_to :provider
  belongs_to :record
  
end