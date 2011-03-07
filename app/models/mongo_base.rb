class MongoBase
  def self.mongo
    MONGO_DB
  end
  
  include ActiveModel::Validations
  include ActiveModel::MassAssignmentSecurity
  
  def self.add_delegate(key, protect=nil)
    if protect == :protect
      attr_protected key
    end
    
    define_method(key) do
      read_attribute_for_validation(key)
    end
    define_method("#{key.to_s}=".to_sym) do |val|
      set_attribute_value(key, val)
    end
  end
  
  def initialize(attributes = {})
    @attributes = {}
    sanitize_for_mass_assignment(attributes).each do |k, v|
      send("#{k}=", v) if respond_to?("#{k}=")
    end
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
    key_sym = key.to_sym
    @attributes[key_sym] = value
  end
end