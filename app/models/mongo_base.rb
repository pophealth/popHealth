class MongoBase
  def self.mongo
    MONGO_DB
  end
  
  def self.add_delegate(key)
    define_method(key) do
      read_attribute_for_validation(key)
    end
    define_method("#{key.to_s}=".to_sym) do |val|
      set_attribute_value(key, val)
    end
  end
end