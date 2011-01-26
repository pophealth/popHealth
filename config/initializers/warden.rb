Rails.configuration.middleware.use RailsWarden::Manager do |manager|
    manager.default_strategies :my_strategy
    manager.failure_app = LoginController
  end

  # Setup Session Serialization
  class Warden::SessionSerializer
    def serialize(record)
      [record.class, record.id]
    end

    def deserialize(keys)
      klass, id = keys
      klass.find(:first, :conditions => { :id => id })
    end
  end

  # Declare your strategies here
  Warden::Strategies.add(:my_strategy) do
   def authenticate!
     # do stuff
   end 
  end