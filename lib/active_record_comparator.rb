# This module will compare two ActiveRecord objects. This isn't a check for equality, but a check
# see if something should pass validation as meeting the requirements of another object.
#
# To be concrete, let's say that we are comparing Allergy A to Allergy B. We are going to try
# to validate Allergy B against Allergy A. The following rules will apply:
# * If an attribute is present in Allergy A, it must be present and equal in Allergy B
# * If an attribute is not present in Allergy A, it will not be checked in Allergy B
# * It follows from above that if an attribute is not present in Allergy A, it may be present in Allergy B and set to any value
# * Id's are not checked in this comparison. That means the id's of the records themselves are not checked. 
#   This is a check for "content". The same goes for foreign keys. Association content should match, but don't have to be in the same record
module ActiveRecordComparator
  def self.filter_attributes(attrs)
    attrs.reject do |attribute|
      ['updated_on', 'updated_at', 'created_on', 'created_at', 'id'].include?(attribute) ||
      attribute.match(/.*\_id$/)
    end
  end
  
  def self.compare(record_a, record_b)
    errors = nil
    filtered_attributes = filter_attributes(record_a.attribute_names)
    filtered_attributes.each do |attribute_name|
      if record_a.attribute_present?(attribute_name)
        unless record_a.send(attribute_name).eql?(record_b.send(attribute_name))
          errors ||= []
          errors << ContentError.new(:section => record_a.class.name, :field_name => attribute_name.humanize,
                                     :error_message => "Expected #{record_a.send(attribute_name)}, but found #{record_b.send(attribute_name)}")
        end
      end
    end
    errors
  end
end