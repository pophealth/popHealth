class Practice
  include Mongoid::Document

  field :name, type: String
  field :organization, type: String
  field :address, type: String
  field :provider_id, type: BSON::ObjectId
  
  validates_presence_of :name, :organization
  validates :name, uniqueness: true
  belongs_to :provider, dependent: :destroy
  has_many :users
  has_many :records
  
end
