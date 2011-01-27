require 'uniq_validator'
class User < MongoBase
  
  
  def self.add_delegate(key)
    eval %{
      def #{key.to_s} 
        read_attribute_for_validation(:#{key.to_s})
      end
    
     def #{key}=(val) 
        set_attribute_value('#{key.to_s}',val)
     end
    }
  end
  
  add_delegate :password
  add_delegate :username
  add_delegate :first_name
  add_delegate :last_name
  add_delegate :email
  
  add_delegate :locked
  add_delegate :reset_key
  add_delegate :verified
  add_delegate :verify_key
  add_delegate :_id
  
  include ActiveModel::Validations
  
  validates_presence_of :first_name, :last_name
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i},
                    :uniq=>true
  validates :username, :presence => true,:length => {:minimum => 3, :maximum => 254}
  validates :username, :uniq=>true, :if=>:new_record?
  validates :password, :presence =>true,
                      :length => { :minimum => 5, :maximum => 40 }, :confirmation=>true


  add_delegate :password_confirmation

  # Lookup a user by the username and password,
  # param [String] username the username to look for
  # param [Sting] password the clear text password to look for, pass will be hashed to check                     
  def self.authenticate(username, password)
   u = mongo['users'].find_one({username:username, password:hash_password(password)})
   return User.new(u) if u   
  end


  # See if the username already exists
  # param [String] username
  def self.check_username(username)
    mongo['users'].find_one({username:attributes[:username]})
  end
  
  # Find users based on hash of key value pairs
  # param [Hash] params key value pairs to use as a filter - same as would be passed to mongo collection
  def self.find(params)
    mongo['users'].find(params).collect{|u| User.new(u)}
  end

  # Find one user based on hash of key value pairs
  # param [Hash] params key value pairs to use as a filter - same as would be passed to mongo collection
  def self.find_one(params)
     atts =mongo['users'].find_one(params)
     atts ? User.new(atts) : nil
  end
  
  def initialize(attributes = {})
    @attributes = attributes || {}
  end
  
  # get the value for a field
  # param [String || Symbol] key the value to get
  def read_attribute_for_validation(key)
      @attributes[key.to_sym] || @attributes[key.to_s]
  end
  
  # Set the value for a field, this abstration is here so that symbols and strings can be used for key values
  # param [String || Symbol] key the field to set
  # param [String] val the value to set for the field
  def set_attribute_value(key, value)
      if @attributes.has_key?(key.to_sym) 
         @attributes[key.to_sym] = value
       else
         @attributes[key.to_s] = value
       end
  end
  
  # Lock the user
  def lock
    set_attribute_value('locked',true)
  end
  
  # Is this user currently locked
  def is_locked? 
    read_attribute_for_validation('locked') == true
  end

  # Is there currently a reset_key set for this user to reset their password
  def is_reset?
      read_attribute_for_validation( 'reset_key')
  end
  
  #set the password - the value is hashed before it is set
  # param [String] val the value of the password
  def password=(val)
    set_attribute_value('password', hash_password(val))
  end
  
  # Set the password confirmation field
  # param [String] val the password_confirmation value
  def password_confirmation=(val)
     set_attribute_value('password_confirmation', hash_password(val))
  end
  
  # Update the password and confirmation fields. This method hashes the values before they are set
  # param [String] password
  # params [String] password_confirmation
  def update_password(pass,verify_password)
    password = pass
    password_confirmation = verify_password
  end


  # Merge the attributes with the record
  # @param [Hash] attributes the attributes to merge into this record
  def update(attributes)
    @attributes.merge!(attributes)
  end
  
  #Save the user to the db, save only takes place if the record is valid based on the validation
  def save
     
     if(valid?)
       User.mongo['users'].save(@attributes)
       return true
     end
     return false
  end
  
  # Is this a new record, ie it has not been saved yet so there is no _id
  def new_record?
    _id.nil?
  end
  
  # Remove the user from the db
  def destroy
    User.mongo['users'].remove(@attributes)
  end
  
  # reload the user from the stored values in the db, this only works for saved records
  def reload
    unless new_record?
      @attributes = mongo['users'].find_one({'_id' => _id})
    end
    
  end
  
  
  private 
  
  def self.hash_password(pass)
    pass
  end
  
  
end
