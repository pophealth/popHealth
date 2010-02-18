class AddressC32Importer
  extend ImportHelper

  def self.import(address_element)

    addr = Address.new
    if address_element
      with_element(address_element) do |element|
        addr.street_address_line_one = element.find_first("cda:streetAddressLine[1]").try(:text)
        addr.street_address_line_two = element.find_first("cda:streetAddressLine[2]").try(:text)
        addr.city = element.find_first("cda:city").try(:text)
        addr.state = element.find_first("cda:state").try(:text)
        addr.postal_code = element.find_first("cda:postalCode").try(:text)

        country_code = element.find_first("cda:country").try(:text)
        if country_code
          addr.iso_country = IsoCountry.find_by_code(country_code)
        end
      end
    end
    addr
  end

end