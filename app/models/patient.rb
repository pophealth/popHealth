class Patient
  include Mongoid::Document
  
  embeds_many :provider_histories, class_name: 'ProviderHistory', inverse_of: :patient
  
  self.collection_name = 'records'
  
# field definitions not necessary for retrieval
#  field :first, :type => String
#  field :last, :type => String

end

