require 'uniq_validator'

class User

  include Mongoid::Document
  
  before_create :set_defaults
  
  DEFAULT_EFFECTIVE_DATE = Time.gm(2011, 1, 1)
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]


   ## Database authenticatable
   field :encrypted_password, :type => String

   ## Recoverable
   field :reset_password_token,   :type => String
   field :reset_password_sent_at, :type => Time

   ## Rememberable
   field :remember_created_at, :type => Time

   ## Trackable
   field :sign_in_count,      :type => Integer
   field :current_sign_in_at, :type => Time
   field :last_sign_in_at,    :type => Time
   field :current_sign_in_ip, :type => String
   field :last_sign_in_ip,    :type => String


  :remember_created_at
  :reset_password_token
  :reset_password_sent_at
  :sign_in_count
  :current_sign_in_at
  :last_sign_in_at
  :current_sign_in_ip
  :last_sign_in_ip
  :effective_date

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
  field :provider, type: Boolean
  
  # Added 8/29/12 by BS for multiple groups per install
  field :teams, type: Array # added from bstrezze 
	  
  scope :ordered_by_username, order_by([:username, :asc])
  
 attr_protected :provider, :admin, :approved, :disabled, :encrypted_password, :remember_created_at, :reset_password_token, :reset_password_sent_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :effective_date

  validates_presence_of :first_name, :last_name

  validates_uniqueness_of :username
  validates_uniqueness_of :email

  validates_acceptance_of :agree_license, :accept => true

  validates :email, presence: true, length: {minimum: 3, maximum: 254}, format: {with: /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i}
  validates :username, :presence => true, length: {minimum: 3, maximum: 254}

  def set_defaults
    self.staff_role ||= APP_CONFIG["default_user_staff_role"]
    self.approved ||= APP_CONFIG["default_user_approved"]
    self.provider = (self.npi != nil)? true : false 
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

	# added from bstrezze
  def team_names
    teamlist = Array.new

    self.teams.each do |team|
      teamlist << MONGO_DB['teams'].find({:_id => team}).to_a[0]["name"]
    end

    return teamlist
  end
  
	  
  
  # =============
  # = Accessors =
  # =============
  def selected_measures
    MONGO_DB['selected_measures'].find({:username => username}).to_a #need to call to_a so that it isn't a cursor
  end
  
  def full_name
    "#{first_name} #{last_name}"
  end
  
  # ===========
  # = Finders =
  # ===========
  def self.by_username(username)
    where(username: username).first
  end
  def self.by_email(email)
    where(email: email).first
  end
  	
	# added from bstrezze
  def self.by_id(id)
    where(_id: id).first
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
