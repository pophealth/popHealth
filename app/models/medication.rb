class Medication < ActiveRecord::Base

  strip_attributes!

  belongs_to :medication_type
  belongs_to :code_system

  include PatientChild
  include Commentable

  def requirements
    {
      :product_coded_display_name => :hitsp_required,
      :product_code => :hitsp_r2_required,
      :code_system_id => :hitsp_r2_required,
      :medication_type_id => :hitsp_r2_required,
      :free_text_brand_name => :hitsp_r2_required,
      :status => :hitsp_r2_optional,
      :quantity_ordered_value => :hitsp_r2_optional,
      :quantity_ordered_unit => :hitsp_r2_optional,
      :expiration_date => :hitsp_r2_optional,
    }
  end

 
  
  def to_c32(xml)
    xml.entry {
      xml.substanceAdministration("classCode" => "SBADM", "moodCode" => "EVN") {
        xml.templateId("root" => "2.16.840.1.113883.10.20.1.24", "assigningAuthorityName" => "CCD")
        xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.8", "assigningAuthorityName" => "HITSP/C32")
        xml.id
        xml.consumable {        
          xml.manufacturedProduct("classCode" => "MANU") {
            xml.templateId("root" => "2.16.840.1.113883.10.20.1.53", "assigningAuthorityName" => "CCD") 
            xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.9", "assigningAuthorityName" => "HITSP/C32") 
            xml.manufacturedMaterial("classCode" => "MMAT", "determinerCode" => "KIND") {
              
             if(product_code && !product_code.blank? && code_system && !code_system.blank?)
              xml.code("code" => product_code, 
                       "displayName" => product_coded_display_name, 
                       "codeSystem" => code_system.code, 
                       "codeSystemName" => code_system.name){
                           xml.originalText(product_coded_display_name)
                       } 
               end         
              if free_text_brand_name 
                xml.name free_text_brand_name
              end
            }
          }
        }
        
        if medication_type
          xml.entryRelationship("typeCode" => "SUBJ") {
            xml.observation("classCode" => "OBS", "moodCode" => "EVN") {                           
              xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.10") 
              xml.code("code" => medication_type.code, 
                       "displayName" => medication_type.name, 
                       "codeSystem" => "2.16.840.1.113883.6.96", 
                       "codeSystemName" => "SNOMED CT")
              xml.statusCode("code" => "completed")
            }  
          }
        end
        
        if status
          xml.entryRelationship("typeCode" => "REFR") {
            xml.observation("classCode" => "OBS", "moodCode" => "EVN") {
              xml.code("code" => "33999-4", 
                       "displayName" => "Status", 
                       "codeSystem" => "2.16.840.1.113883.6.1", 
                       "codeSystemName" => "LOINC")
              xml.statusCode("code" =>status)
              xml.value("xsi:type" => "CE", 
                        "code" => "55561003", 
                        "displayName" => "Active", 
                        "codeSystem" => "2.16.840.1.113883.6.96", 
                        "codeSystemName" => "SNOMED CT")
            }
          }
        end
        
        if quantity_ordered_value  || quantity_ordered_unit  || expiration_time 
          xml.entryRelationship("typeCode" => "REFR") {
            xml.supply("classCode" => "SPLY", "moodCode" => "INT") {
              xml.templateId("root" => "2.16.840.1.113883.3.88.1.11.32.11")
              if quantity_ordered_unit 
                xml.id("root" => quantity_ordered_unit, "extension" => "SCRIP#")
              end 
              if expiration_time 
                  xml.effectiveTime("value" => expiration_time.to_s(:brief))
              end
              if quantity_ordered_value 
                xml.quantity("value" => quantity_ordered_value)
              end  
            }
          }
        end
        
      }
    }
  end
  
  def randomize()
    p = rand

    if p < 0.35
      self.product_coded_display_name = "Aspirin"
      self.product_code = "R16CO5Y76E"
      self.code_system = CodeSystem.find_by_code("2.16.840.1.113883.4.9")  #FDA UNII
      self.free_text_brand_name = ""
      self.medication_type = MedicationType.find :random
      self.expiration_time = DateTime.new(2008 + rand(4), rand(12) + 1, rand(28) + 1)
    else
      product_names = ["Metoprolol", "Cephalexin", "Albuterol inhalant", "Prednisone", "Clopidogrel"]
      product_codes = [430618, 197454, 307782, 312615, 309362]
      brand_names = ["Generic Brand",  "Keflex", "ACTUAT inhalant", "", "Plavix"]
      index = rand(6)

      self.product_coded_display_name = product_names[index]
      self.product_code = product_codes[index]
      self.code_system = CodeSystem.find_by_code("2.16.840.1.113883.6.88")  #RxNorm
      self.free_text_brand_name = brand_names[index]
      self.medication_type = MedicationType.find :random
      self.expiration_time = DateTime.new(2008 + rand(4), rand(12) + 1, rand(28) + 1)
    end
  end
  
  def self.c32_component(medications, xml)
    # Start Medications
    if medications.size > 0
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.8", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "10160-0", 
                   "displayName" => "History of medication use", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title "Medications"
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Product Display Name"
                  xml.th "Free Text Brand Name"
                  xml.th "Ordered Value"
                  xml.th "Ordered Unit"
                  xml.th "Expiration Time"
                end
              end
              xml.tbody do
                medications.try(:each) do |medication|
                  xml.tr do
                    if medication.product_coded_display_name != nil
                      xml.td do
                        xml.content(medication.product_coded_display_name, 
                                    "ID" => "medication-"+medication.id.to_s)
                      end
                    else
                      xml.td
                    end 
                    if medication.free_text_brand_name != nil
                      xml.td medication.free_text_brand_name
                    else
                      xml.td
                    end  
                    if medication.quantity_ordered_value != nil
                      xml.td medication.quantity_ordered_value
                    else
                      xml.td
                    end    
                    if medication.quantity_ordered_unit != nil
                      xml.td medication.quantity_ordered_unit
                    else
                      xml.td
                    end   
                    if medication.expiration_time != nil
                      xml.td medication.expiration_time.to_s(:brief)
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
    # End Medications 
  end
  
end
