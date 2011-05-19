require 'uniq_validator'

class User
  include Mongoid::Document
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]
  
  field :first_name, :type => String
  field :last_name, :type => String
  field :username, :type => String
  field :email, :type => String
  field :company, :type => String
  field :company_url, :type => String

  field :registry_id, :type => String
  field :registry_name, :type => String
  field :npi, :type => String
  field :tin, :type => String

  field :agree_license, :type => Boolean

  field :effective_date, :type => Integer

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :username
  validates_uniqueness_of :email
  validates_acceptance_of :agree_license
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :username, :presence => true, :length => {:minimum => 3, :maximum => 254}
  validates :password, :presence => true
end
