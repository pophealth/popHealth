class ProviderPerformance
  include Mongoid::Document
  
  field :start_date, type: Integer
  field :end_date, type: Integer
  
  belongs_to :provider
  embedded_in :record
  
end