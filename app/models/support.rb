class Support < ActiveRecord::Base

  strip_attributes!

  belongs_to :contact_type
  belongs_to :relationship

  include PatientChild
  include PersonLike
  include MatchHelper

  def requirements
    {
      :contact_type_id => :required,
      :relationship_id => :hitsp_r2_required,
    }
  end

 

  def to_c32(xml)
    if contact_type && contact_type.code == "GUARD"
      xml.guardian("classCode" => contact_type.code) do
        xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.3")
        if relationship
          xml.code("code" => relationship.code, 
                   "displayName" => relationship.name,
                   "codeSystem" => "2.16.840.1.113883.5.111",
                   "codeSystemName" => "RoleCode")
        end
        address.try(:to_c32, xml)
        telecom.try(:to_c32, xml)
        xml.guardianPerson do
          person_name.to_c32(xml)
        end
      end
    else
      xml.participant("typeCode" => "IND") do
        xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.3")
        xml.time do
          if start_support 
            xml.low('value'=> start_support.to_s(:brief))
          end
          if end_support
            xml.high('value'=> end_support.to_s(:brief))
          end
        end
        xml.associatedEntity("classCode" => contact_type.code) do
          if relationship
            xml.code("code" => relationship.code, 
                     "displayName" => relationship.name,
                     "codeSystem" => "2.16.840.1.113883.5.111",
                     "codeSystemName" => "RoleCode")
          end
          address.try(:to_c32, xml)
          telecom.try(:to_c32, xml) 
          xml.associatedPerson do
            person_name.try(:to_c32, xml)
          end
        end
      end
    end            
  end

  def randomize(birth_date)
    self.start_support = DateTime.new(birth_date.year + rand(DateTime.now.year - birth_date.year), rand(12) + 1, rand(28) +1)
    self.end_support = DateTime.new(start_support.year + rand(DateTime.now.year - start_support.year), rand(12) + 1, rand(28) +1)
    self.person_name = PersonName.new
    self.person_name.first_name = Faker::Name.first_name
    self.person_name.last_name = Faker::Name.last_name
    self.address = Address.new
    self.address.randomize()
    self.telecom = Telecom.new
    self.telecom.randomize()
    self.contact_type = ContactType.find :random
    self.relationship = Relationship.find :random
  end

end
