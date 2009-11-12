class Procedure < ActiveRecord::Base
  strip_attributes!
  
  belongs_to :procedure_status_code

  include PatientChild

  def requirements
    {
      :procedure_id => :required,
      :code => :required,
      :procedure_date => :hitsp_r2_optional,
      :procedure_status_code_id => :nhin_required,
    }
  end

  def to_c32(xml)
    xml.entry("typeCode" => "DRIV") do
      xml.procedure("classCode" => "PROC", 
                    "moodCode" => "EVN") do
        xml.templateId("root" => "2.16.840.1.113883.10.20.1.29")
        if self.procedure_id
          xml.id("root" => self.procedure_id)
        end
        if self.code
          xml.code("code" => self.code, "codeSystem" => "2.16.840.1.113883.6.96") do 
            xml.originalText do
              xml.reference("value" => "Proc-"+self.id.to_s)
            end
          end
        end
        xml.statusCode("code" => "completed")
        if self.procedure_date
          xml.effectiveTime("value" => procedure_date.to_s(:year))
        end 
      end
    end 

    # HL7's example static, structured  procedure XML data
    #xml.entry("typeCode" => "DRIV") do
    #  xml.procedure("classCode" => "PROC", "moodCode" => "EVN") do
    #    xml.templateId("root" => "2.16.840.1.113883.10.20.1.29")
    #    xml.id("root" => "e401f340-7be2-11db-9fe1-0800200c9a66")
    #    xml.code("code" => "52734007", "codeSystem" => "2.16.840.1.113883.6.96", "displayName" => "Total hip replacement") do
    #      xml.originalText do
    #        xml.reference("value" => "#{}Proc-"+self.id.to_s)
    #      end
    #      xml.qualifier do
    #        xml.name("code" => "272741003", "displayName" => "Laterality")
    #        xml.value("code" => "7771000", "displayName" => "Left")
    #      end
    #    end
    #    xml.statusCode("code" => "completed")
    #    xml.effectiveTime("value" => "1998")
    #    xml.participant("typeCode" => "DEV") do
    #      xml.participantRole("classCode" => "MANU") do
    #        xml.templateId("root" => "2.16.840.1.113883.10.20.1.52")
    #        xml.id("root" =>"03ca01b0-7be1-11db-9fe1-0800200c9a66")
    #      end
    #    end
    #  end
    #end

  end

  def randomize(birth_date)
    # TODO: need to have a pool of potential procdures in the database
    self.name = "Total hip replacement, left"
    self.procedure_id = "e401f340-7be2-11db-9fe1-0800200c9a66"
    self.code = "52734007"
    self.procedure_status_code = ProcedureStatusCode.find :random
    self.procedure_date = DateTime.new(birth_date.year + rand(DateTime.now.year - birth_date.year), rand(12) + 1, rand(28) +1)
  end

  def self.c32_component(procedures, xml)
    unless procedures.empty?
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.12", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "47519-4", 
                   "displayName" => "Procedures", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title("Procedures")
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Procedure Name"
                  xml.th "Date"
                end
              end
              xml.tbody do
               procedures.try(:each) do |procedure|
                  xml.tr do
                    if procedure.name
                      xml.td do
                        xml.content(procedure.name, 
                                     "ID" => "Proc-"+procedure.id.to_s) 
                      end
                    else
                      xml.td
                    end 
                    if procedure.procedure_date
                      xml.td(procedure.procedure_date.to_s(:year))
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
  end
end
