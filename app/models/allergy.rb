class Allergy < ActiveRecord::Base

  strip_attributes!

  belongs_to :adverse_event_type
  belongs_to :severity_term
  belongs_to :allergy_status_code
  belongs_to :allergy_type_code

  include PatientChild
  include Commentable

  def requirements
    {
      :free_text_product => :hitsp_optional,
      :product_code => :hitsp_r2_required,
      :adverse_event_type_id => :required,
      :start_event => :hitsp_r2_optional,
      :end_event => :hitsp_r2_optional,
      :allergy_status_code_id => :hitsp_r2_optional,
    }
  end

  def to_c32(xml)
    xml.entry do
      xml.act("classCode" => "ACT", "moodCode" => "EVN") do
        xml.templateId("root" => "2.16.840.1.113883.10.20.1.27")
        xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.6")
        xml.id("root" => "2C748172-7CC2-4902-8AF0-23A105C4401B")
        xml.code("nullFlavor"=>"NA")
        xml.entryRelationship("typeCode" => "SUBJ") do
          xml.observation("classCode" => "OBS", "moodCode" => "EVN") do
            xml.templateId("root" => "2.16.840.1.113883.10.20.1.18")
            if adverse_event_type 
              xml.code("code" => adverse_event_type.code, 
                       "displayName" => adverse_event_type.name, 
                       "codeSystem" => "2.16.840.1.113883.6.96", 
                       "codeSystemName" => "SNOMED CT")
            else
              xml.code("nullFlavor"=>"N/A")
            end
            xml.statusCode("code"=>"completed")
            if start_event != nil || end_event != nil
              xml.effectiveTime do
                if start_event != nil 
                  xml.low("value" => start_event.to_s(:brief))
                end
                if end_event != nil
                  xml.high("value" => end_event.to_s(:brief))
                else
                  xml.high("nullFlavor" => "UNK")
                end
              end
            end
            xml.participant("typeCode" => "CSM") do
              xml.participantRole("classCode" => "MANU") do
                xml.playingEntity("classCode" => "MMAT") do
                  xml.code("code" => product_code, 
                           "displayName" => free_text_product, 
                           "codeSystem" => "2.16.840.1.113883.6.88", 
                           "codeSystemName" => "RxNorm")
                  xml.name free_text_product
                end
              end
            end
            if allergy_status_code
              xml.entryRelationship("typeCode" => "REFR") do
                xml.observation("classCode" => "OBS", "moodCode" => "EVN") do
                  xml.templateId("root" => "2.16.840.1.113883.10.20.1.39")
                  xml.code("code" => "33999-4", 
                           "displayName" => "Status",
                           "codeSystem" => "2.16.840.1.113883.6.1", 
                           "codeSystemName" => "AlertStatusCode")
                  xml.statusCode("code" => "completed")
                  xml.value("xsi:type" => "CE", 
                            "code" => allergy_status_code.code,
                            "displayName" => allergy_status_code.name,
                            "codeSystem" => "2.16.840.1.113883.6.96", 
                            "codeSystemName" => "SNOMED CT") 
                end
              end
            end
          end
        end
        #if severity_term
        #  xml.entryRelationship("typeCode" => "SUBJ", "inversionInd" => "true") do
        #    xml.observation("classCode" => "OBS", "moodCode" => "EVN") do
        #      xml.templateId("root" => "2.16.840.1.113883.10.20.1.55")
        #     xml.code("code" => "SEV", 
        #              "displayName" => "Severity",
        #               "codeSystem" => "2.16.840.1.113883.5.4", 
        #               "codeSystemName" => "ActCode")
        #     xml.text do
        #        xml.reference("value" => "#severity-" + id.to_s)
        #     end
        #     xml.statusCode("code" => "completed")
        #     xml.value("xsi:type" => "CD", 
        #               "code" => severity_term.code,
        #              "displayName" => severity_term.name,
        #               "codeSystem" => "2.16.840.1.113883.6.96", 
        #               "codeSystemName" => "SNOMED CT")
        #    end
        #  end
        #end
      end
    end

  end

  def randomize(birth_date)
    possible_allergen = ["Asprin 1191", "Codeine 2670", "Penicillin 70618"]
    allergen = possible_allergen[rand(3)]
    self.free_text_product = allergen.split[0]
    self.product_code = allergen.split[1]

    self.start_event = DateTime.new(birth_date.year + rand(DateTime.now.year - birth_date.year), rand(12) + 1, rand(28) +1)

    self.adverse_event_type = AdverseEventType.find :random
    self.severity_term = SeverityTerm.find :random
    self.allergy_type_code = AllergyTypeCode.find :random
    self.allergy_status_code = AllergyStatusCode.find :random
  end

  def self.c32_component(allergies, xml)
    if allergies.size > 0
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.2", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "48765-2", 
                   "codeSystem" => "2.16.840.1.113883.6.1")
          xml.title "Allergies, Adverse Reactions, Alerts"
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Substance"
                  xml.th "Event Type"
                  xml.th "Severity"
                end
              end
              xml.tbody do
                allergies.try(:each) do |allergy|
                  xml.tr do
                    if allergy.free_text_product != nil
                      xml.td allergy.free_text_product
                    else
                      xml.td
                    end 
                    if allergy.adverse_event_type != nil
                      xml.td allergy.adverse_event_type.name
                    else
                      xml.td
                    end  
                    if allergy.severity_term != nil
                      xml.td do
                        xml.content(allergy.severity_term.name, 
                                    "ID" => "severity-" + allergy.id.to_s)
                      end
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
