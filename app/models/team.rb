class Team
  include Mongoid::Document
  
  field :name, type: String
  has_many :providers
  
  scope :alphabetical, -> { asc(:username) }
end