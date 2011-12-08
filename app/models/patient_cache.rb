class PatientCache
  include Mongoid::Document
  
  store_in :patient_cache
  
  field :first, type: String
  field :last, type: String
  field :patient_id, type: String
  field :birthdate, type: Integer
  field :gender, type: String
  
  scope :by_provider, ->(prov, effective_date) { (effective_date) ? where(provider_queries(prov.id, effective_date)) : where('provider_performances.provider_id'=>prov.id)  }

  private 
  
  def self.provider_queries(provider_id, effective_date)
   {'$or' => [provider_query(provider_id, effective_date,effective_date), provider_query(provider_id, nil,effective_date), provider_query(provider_id, effective_date,nil)]}
  end
  def self.provider_query(provider_id, start_before, end_after)
    {'value.provider_performances' => {'$elemMatch' => {'provider_id' => provider_id, 'start_date'=> {'$lt'=>start_before}, 'end_date'=> {'$gt'=>end_after} } }}
  end
  
end
