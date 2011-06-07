class Log
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :username, :type => String
  field :event, :type => Symbol
  field :patient_id, :type => String
  field :checksum, :type => String
end