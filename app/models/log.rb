class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :username, :type => String
  field :event, :type => String
  field :description, :type => String
  field :patient_id, :type => String
  field :checksum, :type => String
end