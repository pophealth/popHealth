class Address < ActiveRecord::Base

  strip_attributes!

  belongs_to :iso_country
  belongs_to :iso_state
  belongs_to :zip_code
  belongs_to :addressable, :polymorphic => true

  after_save { |r| r.addressable.try(:patient).try(:update_attributes, :updated_at => DateTime.now) }

  def blank?
    %w[ street_address_line_one street_address_line_two
        city state postal_code iso_country_id ].all? {|a| read_attribute(a).blank? }
  end

  def requirements
    case addressable_type
      when 'RegistrationInformation':
        {
          :street_address_line_one => :required,
          :city => :required,
          :state => :required,
          :postal_code => :required,
          :iso_country_id => :required,
        }
      when 'Support', 'Provider', 'Encounter':
        {
          :street_address_line_one => :hitsp_r2_optional,
          :city => :hitsp_r2_optional,
          :state => :hitsp_r2_required,
          :postal_code => :hitsp_r2_optional,
          :iso_country_id => :hitsp_r2_required,
        }
      when 'InsuranceProviderSubscriber':
        {
          :state => :required,
          :iso_country_id => :required,
        } 
      when 'InsuranceProviderPatient':
        {
          :street_address_line_one => :hitsp_r2_optional,
          :city => :hitsp_r2_optional,
          :state => :hitsp_r2_optional,
          :postal_code => :hitsp_r2_optional,
          :iso_country_id => :hitsp_r2_optional,
        }
      when 'InsuranceProviderGuarantor':
        {
          :state => :required,
          :iso_country_id => :required,
        }
      when 'AdvanceDirective':
        {
          :street_address_line_one => :hitsp_r2_optional,
          :city => :hitsp_r2_optional,
          :state => :hitsp_r2_optional,
          :postal_code => :hitsp_r2_optional,
          :iso_country_id => :hitsp_r2_optional,
        }
    end
  end

  

  def to_c32(xml = XML::Builder.new)
    xml.addr do
      if street_address_line_one.present?
        xml.streetAddressLine street_address_line_one
      end
      if street_address_line_two.present?
        xml.streetAddressLine street_address_line_two
      end
      if city.present?
        xml.city city
      end
      if state.present?
        xml.state state
      end
      if postal_code.present?
        xml.postalCode postal_code
      end
      if iso_country 
        xml.country iso_country.code
      end
    end
  end

  def randomize()
    zip = ZipCode.find :random
    self.street_address_line_one = Faker::Address.street_address
    self.city = zip.town
    self.state = zip.state
    self.postal_code = zip.zip

    self.iso_country = IsoCountry.find_by_code("US") #sets the country as the USA

  end

end
