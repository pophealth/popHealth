class Team
  include Mongoid::Document
  field :name, type: String
  field :providers, type: Array, default: []
  field :user_id, type: BSON::ObjectId
end
