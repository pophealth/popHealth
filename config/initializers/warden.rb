Rails.configuration.middleware.use RailsWarden::Manager do |manager|
  manager.default_strategies :my_strategy
  manager.failure_app = LoginController
end

# Setup Session Serialization
class Warden::SessionSerializer
  def serialize(record)
    [record._id]
  end

  def deserialize(keys)
     id = keys[0]
     User.find_one({'_id' => id})
  end
end

# Declare your strategies here
Warden::Strategies.add(:my_strategy) do

  def valid?
    params["username"] || params["password"]
  end

  def authenticate!
    user = User.authenticate(params[:username],params[:password])

    if user && user.verified
      success!(user)
    elsif user
      errors.add(:login, "Account not yet verified")
      fail!
    else
      errors.add(:login, "Username or Password incorrect")
      fail!
    end
  end
end
  