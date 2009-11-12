class InformationSource < ActiveRecord::Base

  strip_attributes!

  include PatientChild
  include PersonLike
  
  def requirements
    {
      :time => :required,
      :document_id => :required,
      :organization_name => :required,
    }
  end


  def to_c32(xml)
    xml.author do
      if self.time
        xml.time("value"=>time.to_s(:brief))
      end
      xml.assignedAuthor do
        xml.id("root"=>document_id)
        xml.assignedPerson do
          xml.name do
            if person_name.name_prefix &&
               person_name.name_prefix.size > 0
              xml.prefix person_name.name_prefix
            end
            if person_name.first_name &&
               person_name.first_name.size > 0
              xml.given(person_name.first_name, "qualifier" => "CL")
            end
            if person_name.last_name &&
               person_name.last_name.size > 0
              xml.family(person_name.last_name, "qualifier" => "BR")
            end
            if person_name.name_suffix &&
               person_name.name_suffix.size > 0
              xml.prefix person_name.name_suffix
            end
          end
        end
        xml.representedOrganization do
          xml.id("root" => "2.16.840.1.113883.19.5")
          xml.name organization_name
        end
      end
    end
  end

  def randomize()
    chars = ('A'..'Z').to_a
    char = chars[rand(chars.length)]
    self.time =  DateTime.new(2000 + rand(9), rand(12) + 1, rand(28) + 1)
    self.person_name = PersonName.new
    self.person_name.first_name = Faker::Name.first_name
    self.person_name.last_name = Faker::Name.last_name
    self.document_id = 'ABC-1234567-' + char + char
  end

end
