require 'uniq_validator'

class User < MongoBase

  include ActiveModel::Conversion
  
  add_delegate :password, :protect
  add_delegate :username
  add_delegate :first_name
  add_delegate :last_name
  add_delegate :email
  add_delegate :company
  add_delegate :company_url

  add_delegate :registry_id
  add_delegate :registry_name
  add_delegate :npi
  add_delegate :tin

  add_delegate :reset_key, :protect
  add_delegate :validation_key, :protect
  add_delegate :validated, :protect
  add_delegate :_id
  add_delegate :effective_date

  validates_presence_of :first_name, :last_name
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i},
                    :uniq=>true
  validates :username, :presence => true, :length => {:minimum => 3, :maximum => 254}
  validates :username, :uniq => true, :if => :new_record?
  validates :password, :presence => true

  # Lookup a user by the username and password,
  # param [String] username the username to look for
  # param [Sting] password the clear text password to look for, pass will be hashed to check                     
  def self.authenticate(username, password)
    u = mongo['users'].find_one(:username => username)
    if u
      bcrypt_pw = BCrypt::Password.new(u['password'])
      if bcrypt_pw.is_password?(password)
        return User.new(u)
      end
    end
    return nil
  end

  # See if the username already exists
  # param [String] username
  def self.check_username(username)
    mongo['users'].find_one(:username => @attributes[:username])
  end

  # Find users based on hash of key value pairs
  # param [Hash] params key value pairs to use as a filter - same as would be passed to mongo collection
  def self.find(params)
    mongo['users'].find(params).map do |model_attributes| 
      create_user_from_db(model_attributes)
    end
  end

  # Find one user based on hash of key value pairs
  # param [Hash] params key value pairs to use as a filter - same as would be passed to mongo collection
  def self.find_one(params)
    model_attributes = mongo['users'].find_one(params)
    create_user_from_db(model_attributes)
  end

  # Merge the attributes with the record
  # @param [Hash] attributes the attributes to merge into this record
  def update(attributes)
    @attributes.merge!(attributes)
  end

  def salt_and_store_password(new_password)
    @attributes[:password] = BCrypt::Password.create(new_password)
  end
  
  #Save the user to the db, save only takes place if the record is valid based on the validation
  def save
    if valid?
      User.mongo['users'].save(@attributes)
      return true
    end
    return false
  end
  
  def validate_account!
    self.validation_key = nil
    self.validated = true
    save
  end
  
  def reset_password!
    self.reset_key = nil
    save
    self.password = nil
  end
  
  def unverified?
    validated.nil?
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
  
  def persisted?
    ! new_record?
  end
  
  def id
    _id
  end
  
  private
  
  # Creates a User from a Hash. This method will also ensure that attributes protected from
  # mass assignment are set. So this method should only be used when pulling information from
  # MongoDB. It should not be used to handle params hashes from web requests.
  def self.create_user_from_db(user_document)
    user = nil
    if user_document
      user = User.new(user_document)
      protected_attributes.each {|attribute| user.send("#{attribute}=", user_document[attribute])}
    end

    user
  end

end
