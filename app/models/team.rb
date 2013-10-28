class Team
  include Mongoid::Document
  
  field :name, type: String
  has_many :providers
  
  scope :alphabetical, order_by([:name, :asc])
  
  validate :name, :uniqueness => true
    
	# added from bstrezze
  def self.userfilter(current_user)
    if current_user.admin?
      all
    else
      any_in(:_id => current_user.teams)
    end
  end 
  
end
