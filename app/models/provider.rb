class Provider < ActiveRecord::Base

  strip_attributes!

  belongs_to :provider_type
  belongs_to :provider_role

  include PatientChild
  include PersonLike
  include Commentable

  def requirements
    {
      :start_service => :hitsp_optional,
      :end_service => :hitsp_optional,
      :provider_type_id => :hitsp_r2_optional,
      :provider_role_id => :hitsp_r2_optional,
      :provider_role_free_text => :hitsp_r2_optional,
      :organization => :hitsp_r2_optional,
      :patient_identifier => :hitsp_r2_optional,
    }
  end


  def to_c32(xml)
    xml.performer("typeCode" => "PRF") do
      xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.4", 
                     "assigningAuthorityName" => "HITSP/C32")
      unless provider_role.blank?
        provider_role.to_c32(xml,provider_role_free_text)
      end
    
      xml.time do
        if start_service 
          xml.low('value'=> start_service.to_s(:brief))
        end
        if end_service 
          xml.high('value'=> end_service.to_s(:brief))
        end
      end

      xml.assignedEntity do
        xml.id
        provider_type.try(:to_c32, xml)
        address.try(:to_c32, xml)
        telecom.try(:to_c32, xml)  
        xml.assignedPerson do
          person_name.try(:to_c32, xml)
        end

        unless organization.blank?
          xml.representedOrganization do
            xml.id("root" => "2.16.840.1.113883.3.72.5", 
                   "assigningAuthorityName" => organization) 
            xml.name(organization)
          end
        end

        unless patient_identifier.blank?
          xml.patient("xmlns"=>"urn:hl7-org:sdtc") do
            xml.id("xmlns"=>"urn:hl7-org:sdtc","root" => patient_identifier,
                   "extension" => "MedicalRecordNumber")
          end
        end
      end
    end
  end

  def randomize(reg_info)
    self.address = Address.new
    self.person_name = PersonName.new
    self.telecom = Telecom.new
    self.person_name.first_name = Faker::Name.first_name
    self.person_name.last_name = Faker::Name.last_name

    self.start_service = DateTime.new(reg_info.date_of_birth.year + rand(DateTime.now.year - reg_info.date_of_birth.year), rand(12) + 1, rand(28) + 1)
    self.end_service = DateTime.new(self.start_service.year + rand(DateTime.now.year - self.start_service.year), rand(12) + 1, rand(28) + 1)

    self.provider_type = ProviderType.find :random
    self.provider_role = ProviderRole.find :random

    #Creates the address of the healthcare provider. Makes it in the same state/town as the patient
    self.address.street_address_line_one = Faker::Address.street_address
    self.address.city = reg_info.address.city
    self.address.state = reg_info.address.state
    self.address.iso_country = reg_info.address.iso_country
    self.address.postal_code = reg_info.address.postal_code

    self.telecom.randomize()
  end

  def self.c32_component(providers, xml)
    xml.documentationOf do
      xml.serviceEvent("classCode" => "PCPR") do
        xml.effectiveTime do
          xml.low('value'=> "0")
          xml.high('value'=> "2010")
        end
        yield
      end
    end
  end
end
