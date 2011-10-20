class Record
  include Mongoid::Document
  
  field :first, type: String
  field :last, type: String
  field :patient_id, type: String
  field :birthdate, type: Integer
  field :gender, type: String
  field :measures, type: Hash
  
  has_and_belongs_to_many :providers, inverse_of: :records
  
end