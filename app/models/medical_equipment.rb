class MedicalEquipment < ActiveRecord::Base
  strip_attributes!

  include PatientChild

  def to_c32(xml)

    xml.entry("typeCode" => "DRIV") do
      xml.supply("classCode" => "SPLY", "moodCode" => "EVN") do
        xml.templateId("root" => "2.16.840.1.113883.10.20.1.34")
        if supply_id
          xml.id("root" => supply_id)
        end
        xml.statusCode("code" => "completed")
        if date_supplied
          xml.effectiveTime("xsi:type"=>"IVL_TS") do 
            xml.center("value" => date_supplied.to_s(:brief))
          end
        end
        xml.participant("typeCode" => "DEV") do
          xml.participantRole("classCode" => "MANU") do
            xml.templateId("root" => "2.16.840.1.113883.10.20.1.52")
            if name && code
              xml.playingDevice do
                xml.code("code" => code,
                         "codeSystem" => "2.16.840.1.113883.6.96",
                         "displayName" => name)
              end
            end
          end
        end
      end
    end
  end

  def randomize(birth_date)
    # TODO: need to have a pool of potential medical equipments in the database
    self.name = "Automatic implantable cardioverter defibrillator"
    self.code = "72506001"
    self.supply_id = "03ca01b0-7be1-11db-8fe1-0822200c9a33"
    self.date_supplied = DateTime.new(birth_date.year + rand(DateTime.now.year - birth_date.year), rand(12) + 1, rand(28) +1)
  end

  def self.c32_component(medical_equipments, xml)
    # Start Medical Equipment
    unless medical_equipments.empty?
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.7", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "46264-8", 
                   "displayName" => "Medical Equipment", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title("Medical Equipment")
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Supply/Device"
                  xml.th "Date Supplied"
                end
              end
              xml.tbody do
               medical_equipments.try(:each) do |medical_equipment|
                  xml.tr do
                    if medical_equipment.name
                      xml.td(medical_equipment.name)
                    else
                      xml.td
                    end 
                    if medical_equipment.date_supplied
                      xml.td(medical_equipment.date_supplied)
                    else
                      xml.td
                    end 
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
    # End Medical Equipments
  end
  
end
