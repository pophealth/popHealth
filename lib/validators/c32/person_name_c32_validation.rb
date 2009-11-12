module PersonNameC32Validation


  include MatchHelper


  # Checks the contents of the REXML::Element passed in to make sure that they match the
  # information in this object. This method expects the the element passed in to be the
  # name element that it will evaluate.
  # Will return an empty array if everything passes. Otherwise,
  # it will return an array of ContentErrors with a description of what's wrong.
  def validate_c32(name_element)
    errors = []
    if name_element
      errors << match_value(name_element, 'cda:prefix', 'name_prefix', self.name_prefix)
      errors << match_value(name_element, 'cda:given', 'first_name', self.first_name)
      errors << match_value(name_element, 'cda:family', 'last_name', self.last_name)
      errors << match_value(name_element, 'cda:suffix', 'name_suffix', self.name_suffix)
    else
      errors << ContentError.new(:section => self.nameable_type.underscore,
                                 :error_message => "name element was null",
                                 :location => name_element.try(:xpath))
    end
    errors.compact
  end

  #Reimplementing from MatchHelper
  def section_name
    self.nameable_type.underscore
  end

  #Reimplementing from MatchHelper  
  def subsection_name
    'person_name'
  end


end
