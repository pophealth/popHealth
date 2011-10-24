class Team
  include Mongoid::Document
  
  field :name, type: String
  has_many :providers
  
  scope :alphabetical, order_by([:name, :asc])
end