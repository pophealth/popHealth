class Patient
  include Mongoid::Document
  
  self.collection_name = 'records'
  
# field definitions not necessary for retrieval
#  field :first, :type => String
#  field :last, :type => String
  

end