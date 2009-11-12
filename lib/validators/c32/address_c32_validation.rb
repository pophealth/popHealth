 module AddressC32Validation

    include MatchHelper

    # Checks the contents of the REXML::Element passed in to make sure that they match the
    # information in this object. This method expects the the element passed in to be the
    # address element that it will evaluate.
    # Will return an empty array if everything passes. Otherwise,
    # it will return an array of ContentErrors with a description of what's wrong.
    def validate_c32(address_element)
      errors = []
      if address_element
        errors << match_value(address_element, 'cda:streetAddressLine[1]', 'street_address_line_one', self.street_address_line_one)
        errors << match_value(address_element, 'cda:streetAddressLine[2]', 'street_address_line_two', self.street_address_line_two)
        errors << match_value(address_element, 'cda:city', 'city', self.city)
        errors << match_value(address_element, 'cda:state', 'state', self.state)
        errors << match_value(address_element, 'cda:postalCode', 'postal_code', self.postal_code)
        if self.iso_country
          errors << match_value(address_element, 'cda:country', 'country', self.iso_country.code)
        end
      else
         errors << ContentError.new(:section => self.addressable_type.underscore, 
                                    :subsection => 'address',
                                    :error_message => 'Address element is nil')
      end
      errors.compact
    end

    #Reimplementing from MatchHelper
    def section_name
      self.addressable_type.underscore
    end

    #Reimplementing from MatchHelper  
    def subsection_name
      'address'
    end


  end