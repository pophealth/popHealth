class Immunization < ActiveRecord::Base

  strip_attributes!

  belongs_to :vaccine
  belongs_to :no_immunization_reason

  include PatientChild
  include Commentable

  def requirements
    {
      :vaccine_id => :required,
      :lot_number_text => :hitsp_r2_optional,
      :refusal => :required,
      :no_immunization_reason_id => :hitsp_r2_optional,
    }
  end
  
  def to_c32(xml)    
    xml.entry('typeCode'=>'DRIV') do
      xml.substanceAdministration('classCode' => 'SBADM', 'moodCode' => 'EVN', 'negationInd' => refusal) do
        xml.templateId("root" => "2.16.840.1.113883.10.20.1.24", "assigningAuthorityName" => "CCD")
        xml.templateId("root" => "2.16.840.1.113883.3.88.11.32.14", "assigningAuthorityName" => "HITSP/C32")
        xml.id('root'=>'41755f58-d7c0-4aab-9f7c-a3a5d8df4581')
        xml.statusCode('code' => 'completed')
        if administration_date
          xml.effectiveTime('xsi:type' => "IVL_TS") do
            xml.center('value' => administration_date.to_s(:brief)) 
          end
        end
        xml.consumable do
          xml.manufacturedProduct do
            xml.templateId('root' => '2.16.840.1.113883.10.20.1.53')
            xml.manufacturedMaterial do
              if vaccine
                vaccine.try(:to_c32, xml)
              end 
              xml.lotNumberText(lot_number_text)
            end
          end
        end
        if no_immunization_reason
          no_immunization_reason.try(:to_c32, xml)
        end 
      end
    end
  end

  def randomize(birth_date)
    self.administration_date = DateTime.new(rand_range(birth_date.year, DateTime.now.year), 
                                            rand(12) + 1, 
                                            rand(28) + 1)
    self.lot_number_text = "mm345-417-DFF"
    p = rand
    # 50% chance patient should be considered of influenza vaccine
    if p < 0.5
      influenza_vaccines = Vaccine.find(:all, :conditions => "name like 'Influenza Virus Vaccine%'")
      random_influenza_vaccine = influenza_vaccines[rand(influenza_vaccines.length)]

      age = Date.today.year - birth_date.year
      if age <= 2
        if p < 0.90
          self.vaccine = random_influenza_vaccine
        end
      elsif age <= 10
        if p < 0.65
          self.vaccine = random_influenza_vaccine
        end
      elsif age <= 20
        if p < 0.40
          self.vaccine = random_influenza_vaccine
        end
      elsif age <= 30
        if p < 0.55
          self.vaccine = random_influenza_vaccine
        end
      elsif age <= 40
        if p < 0.65
          self.vaccine = random_influenza_vaccine
        end
      elsif age <= 50
        if p < 0.80
          self.vaccine = random_influenza_vaccine
        end
      elsif age <= 60
        if p < 0.85
          self.vaccine = random_influenza_vaccine
        end
      elsif age <= 70
        if p < 0.90
          self.vaccine = random_influenza_vaccine
        end
      else
        if p < 0.95
          self.vaccine = random_influenza_vaccine
        end
      end
    # 50% chance for some random vaccine
    else
      self.vaccine = Vaccine.find :random
    end

    # 10% chance that the patient refused the vaccine
    if (rand > 0.1)
      self.refusal = true
      self.no_immunization_reason = NoImmunizationReason.find :random
    else
      self.refusal = false
    end
  end

  def self.c32_component(immunizations, xml)
    # Start Immunizations
    unless immunizations.empty?
      xml.component do
        xml.section do
          xml.templateId("root" => "2.16.840.1.113883.10.20.1.6", 
                         "assigningAuthorityName" => "CCD")
          xml.code("code" => "11369-6", 
                   "codeSystem" => "2.16.840.1.113883.6.1", 
                   "codeSystemName" => "LOINC")
          xml.title("Immunizations")
          xml.text do
            xml.table("border" => "1", "width" => "100%") do
              xml.thead do
                xml.tr do
                  xml.th "Vaccine"
                  xml.th "Administration Date"
                end
              end
              xml.tbody do
                immunizations.each do |immunization|
                  xml.tr do 
                     if immunization.vaccine != nil
                      xml.td(immunization.vaccine.name)
                    end
                    xml.td(immunization.administration_date)
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
    # End Immunizations
  end
end
