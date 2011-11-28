require 'uniq_validator'

class User

  include Mongoid::Document
  
  before_create :set_defaults
  
  DEFAULT_EFFECTIVE_DATE = Time.gm(2010, 12, 31)
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]

  field :first_name, type: String
  field :last_name, type: String
  field :username, type: String
  field :email, type: String
  field :company, type: String
  field :company_url, type: String
  field :registry_id, type: String
  field :registry_name, type: String
  field :npi, :type => String
  field :tin, :type => String
  field :agree_license, type: Boolean
  field :effective_date, type: Integer
  field :admin, type: Boolean
  field :approved, type: Boolean
  field :staff_role, type: Boolean
  field :disabled, type: Boolean
  
  attr_protected :admin, :approved, :disabled, :encrypted_password, :remember_created_at, :reset_password_token, :reset_password_sent_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :effective_date

  validates_presence_of :first_name, :last_name

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  validates_acceptance_of :agree_license, :accept => true

  validates :email, presence: true, length: {minimum: 3, maximum: 254}, format: {with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :username, :presence => true, length: {minimum: 3, maximum: 254}

  def set_defaults
    self.staff_role ||= APP_CONFIG["default_user_staff_role"]
    self.approved ||= APP_CONFIG["default_user_approved"]
    true
  end

  def active_for_authentication? 
    super && approved? && !disabled?
  end

  def inactive_message
    if !approved?
      :not_approved
    else
      super # Use whatever other message
    end
  end

  # =============
  # = Accessors =
  # =============
  def selected_measures
    MONGO_DB['selected_measures'].find({:username => username}).to_a #need to call to_a so that it isn't a cursor
  end

  # ==========
  # = FINDERS =
  # ==========

  def self.find_by_username(username)
    User.first(:conditions => {:username => username})
  end

  # =============
  # = Modifiers =
  # =============

  def grant_admin
    update_attribute(:admin, true)
    update_attribute(:approved, true)
  end

  def approve
    update_attribute(:approved, true)
  end

  def revoke_admin
    update_attribute(:admin, false)
  end

end
