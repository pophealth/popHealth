class PatientCache
  include Mongoid::Document
  
  store_in :patient_cache
  
  field :first, type: String
  field :last, type: String
  field :patient_id, type: String
  field :birthdate, type: Integer
  field :gender, type: String
  
  scope :by_provider, ->(provider, effective_date) { where({'value.provider_performances.provider_id' => provider.id, 'value.effective_date'=>effective_date}) }
  scope :outliers, ->(patient) {where({'value.patient_id'=>patient.id})}
  
  # BS - 120920 - Added to filter patient lists by the teams/providers a user is associated with
  class << self

    def provider_in(provider_list) 
      any_in("value.provider_performances.provider_id" => provider_list)
    end

  end
  
end
