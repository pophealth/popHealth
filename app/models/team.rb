class Team
  include Mongoid::Document
  field :name, type: String
  field :providers, type: Array, default: []
  belongs_to :user
end
