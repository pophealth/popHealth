# lib/email_validator.rb
class UniqValidator < ActiveModel::EachValidator



  def validate_each(record, attribute, value)
    MONGO_DB['users'].find_one({attribute => value})
   if MONGO_DB['users'].find_one({attribute => value})
      record.errors[attribute] << (options[:message] || "is not unquie") 
    end
  end
  
end