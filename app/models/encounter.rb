class Encounter < ActiveRecord::Base

  strip_attributes!

  belongs_to :encounter_type
  belongs_to :encounter_location_code

  include PatientChild
  include Commentable

  include PersonLike

  def requirements
    {
      :encounter_date => :required,
      :encounter_id => :required,
      :free_text => :required,
      :encounter_type_id => :hitsp_r2_optional,
    }
  end

 
  def to_c32(xml)    
    xml.entry('typeCode'=>'DRIV') do
      xml.encounter('classCode'=>'ENC', 'moodCode'=>'EVN') do
        xml.templateId('root' => '2.16.840.1.113883.10.20.1.21', 
                       'assigningAuthorityName' => 'CCD')
        xml.templateId('root' => '2.16.840.1.113883.3.88.11.32.17',
                       'assigningAuthorityName' => 'HITSP/C32') 
        xml.id('root' => encounter_id)
        if encounter_type
          xml.code("code" => encounter_type.code, "codeSystem" => "2.16.840.1.113883.5.4", "displayName" => encounter_type.name) do
            xml.originalText free_text
          end
        end
        if encounter_date != nil 
          xml.effectiveTime do
            xml.low('value'=> encounter_date.to_s(:brief))
          end
        end
        xml.participant('typeCode'=>'PRF') do
          xml.participantRole('classCode' => 'PROV') do
            address.try(:to_c32, xml)
            telecom.try(:to_c32, xml)  
            xml.playingEntity do
              person_name.try(:to_c32, xml)
            end
          end
        end
        if location_name
          xml.participant("typeCode" => "LOC") do
            xml.templateId("root" => "2.16.840.1.113883.10.20.1.45")
            xml.participantRole("classCode" => "SDLOC") do
              xml.id("root" => "2.16.840.1.113883.19.5")
              if encounter_location_code
                xml.code("code" => encounter_location_code.code, 
                         "displayName" => encounter_location_code.name, 
                         "codeSystem" => "2.16.840.1.113883.1.11.17660")
              end
              xml.playingEntity("classCode" => "PLC") do
                xml.name location_name
              end
            end
          end
        end
      end
    end
  end
  
  def randomize(birth_date)
    possible_procedures = ['Heart Valve', 'IUD', 'Artificial Hip', 'Bypass', 'Hypothermia']
    descriptions = ['Heart Valve Replacement', 'Insertion of intrauterine device (IUD)', 'Hip replacement surgery', 'Bypass surgery', 'Treatement for hypothermia']
    possible_procedures_index = rand(possible_procedures.size)

    possible_encounter_locations = ['South Shore Hospital', 'General Hospital', 'Lahey Clinic', 'Darwin Clinic', 'Sagacious Hospital']
    possible_encounter_locations_index = rand(possible_encounter_locations.size)

    self.encounter_date = DateTime.new(birth_date.year + rand(DateTime.now.year - birth_date.year), rand(12) + 1, rand(28) +1)
    self.encounter_id = UUID.generate
    self.person_name = PersonName.new
    self.person_name.name_prefix = 'Dr.'
    self.person_name.first_name = Faker::Name.first_name
    self.person_name.last_name = Faker::Name.last_name
    self.address = Address.new
    self.address.randomize()
    self.telecom = Telecom.new
    self.telecom.randomize()

    self.free_text = possible_procedures[possible_procedures_index]
    self.name = descriptions[possible_procedures_index]    

    self.location_name = possible_encounter_locations[possible_encounter_locations_index]
    
    self.encounter_location_code = EncounterLocationCode.find(:random)
  end

  def self.c32_component(encounters, xml)
    # Start Encounters
    unless encounters.empty?
      xml.component do
        xml.section do
           xml.templateId("root" => "2.16.840.1.113883.10.20.1.3", 
                 "assigningAuthorityName" => "CCD")
           xml.code("code" => "46240-8", 
                    "codeSystem" => "2.16.840.1.113883.6.1", 
                    "codeSystemName" => "LOINC")
           xml.title("Encounters")  
           xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Encounter"
                  xml.th "Encounter Date"
                end
              end
              xml.tbody do
                encounters.each do |encounter|
                  xml.tr do 
                    xml.td(encounter.name)
                    xml.td(encounter.encounter_date)
                  end
                end
              end
            end
          end

          # XML content inspection
          yield

        end
      end
    end
    # End Encounters
  end
end
