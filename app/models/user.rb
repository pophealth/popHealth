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
  add_delegate :_id
  
  include ActiveModel::Validations
  
  validates_presence_of :first_name, :last_name
  validates :email, :presence => true, 
                    :length => {:minimum => 3, :maximum => 254},
                    :format => {:with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i},
                    :uniq=>true
  validates :username, :presence => true,:length => {:minimum => 3, :maximum => 254},:uniq=>true
  validates :password, :presence =>true,
                      :length => { :minimum => 5, :maximum => 40 }, :confirmation=>true


  add_delegate :password_confirmation

                        
  def self.authenticate_user(username, password)
   u = mongo['users'].find_one({username:username, password:hash_password(pass)})
   return User.new(u) if u   
  end


  def self.check_username(username)
    mongo['users'].find_one({username:attributes[:username]})
  end
  

  def self.lock_user(username)
    u =   mongo['users'].find_one({username:attributes[:username]})
    if u 
      u[:locked] = true
      mongo['users'].save(u)
    end  
  end

  
  def self.find(params)
    mongo['users'].find(params).collect{|u| User.new(u)}
  end

  def self.find_one(params)
     User.new mongo['users'].find_one(params)
  end
  
  def initialize(attributes = {})
    @attributes = attributes || {}
  end
  
  def read_attribute_for_validation(key)
      @attributes[key.to_sym] || @attributes[key.to_s]
  end
  
  def set_attribute_value(key, value)
      if @attributes.contains_key?(key.to_sym) 
         @attributes[key.to_sym] = val
       else
         @attributes[key.to_s] = val
       end
  end
  
  def lock
    @attributes['locked']=true
  end
  
  
  def is_locked? 
     @attributes['locked'] == true 
  end

  
  def is_reset?
      read_attribute_for_validation( 'reset_key')
  end
  
  def reset
    #call mailer and set the reset key
  end
  
  def clear_reset
     reset_key = nil
  end
  
  def password=(val)
    set_attribute_value('password', hash_password(val))
  end
  
  def password_confirmation=(val)
     set_attribute_value('password_confirmation', hash_password(val))
  end
  
  
  def update_password(password,verify_password)
     p = hash_password(password)
     vp = hash_password(verify_password)
     @attributes['password'] = p
     @attributes['password_confirmation'] = vp
  end


  def update(attributes)
    @attributes.merge!(attributes)
  end
  def save
     
     if(valid?)
       User.mongo['users'].save(@attributes)
       return true
     end
     return false
  end
  
  def new_record
    _id.nil?
  end
  
  
  def destroy
    
  end
  
  
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
