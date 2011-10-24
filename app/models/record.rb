class Record
  include Mongoid::Document
  
  field :first, type: String
  field :last, type: String
  field :patient_id, type: String
  field :birthdate, type: Integer
  field :gender, type: String
  field :measures, type: Hash
  
  embeds_many :provider_performances
  
  has_many :provider_performances

  
end