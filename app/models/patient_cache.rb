class PatientCache
  include Mongoid::Document
  
  store_in :patient_cache
  
  field :first, type: String
  field :last, type: String
  field :patient_id, type: String
  field :birthdate, type: Integer
  field :gender, type: String
  
  scope :by_provider, ->(provider, effective_date) { where({'value.provider_performances.provider_id' => provider.id, 'value.effective_date'=>effective_date}) }
  
end
