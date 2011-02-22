# lib/email_validator.rb
class UniqValidator < ActiveModel::EachValidator



  def validate_each(record, attribute, value)
    u = MONGO_DB['users'].find_one({attribute => value})
   if u && (record.new_record?  || record._id != u['_id'])
      record.errors[attribute] << (options[:message] || "is not unique") 
    end
  end
  
end