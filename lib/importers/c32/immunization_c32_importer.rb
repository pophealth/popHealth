class ImmunizationC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.6'
  end
  
  def self.entry_xpath
    "cda:entry/cda:substanceAdministration[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.14']"
  end
  
  def self.import_entry(entry_element)
    immunization = Immunization.new
    with_element(entry_element) do |element|
      
      negation_ind = element.find_first("@negationInd").try(:value)
      negation_ind == 'true' ? immunization.refusal = 't' : immunization.refusal = 'f'
      
      admin_date = element.find_first("cda:effectiveTime/cda:center/@value")
      if admin_date
        immunization.administration_date = admin_date.to_s.from_hl7_ts_to_date
      end
      
      product_xpath = "cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/"
      lot_number = element.find_first(product_xpath + "cda:lotNumberText").try(:text)
      if lot_number
        immunization.lot_number_text = lot_number
      end
      
      vaccine_code = element.find_first(product_xpath + "cda:code/@code").try(:value)
      if vaccine_code
        immunization.vaccine = Vaccine.find_by_code(vaccine_code)
      end
      
    end

    immunization
  end
end