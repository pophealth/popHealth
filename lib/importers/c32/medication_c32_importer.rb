class MedicationC32Importer 
  extend ImportHelper
  include MatchHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.8'
  end
  
  def self.entry_xpath
    "cda:entry/cda:substanceAdministration[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.8']"
  end
  
  def self.import_entry(entry_element)
    medication = Medication.new
    with_element(entry_element) do |element|
      
      product_xpath = "cda:consumable/cda:manufacturedProduct/cda:manufacturedMaterial/"
      coded_name = element.find_first(product_xpath + "cda:code/@displayName").try(:value)
      if coded_name
        medication.product_coded_display_name = coded_name
      end
      
      product_code = element.find_first(product_xpath + "cda:code/@code").try(:value)
      if product_code
        medication.product_code = product_code
      end
      
      code_system_oid = element.find_first(product_xpath + "cda:code/@codeSystem").try(:value)
      if code_system_oid
        medication.code_system = CodeSystem.find_by_code(code_system_oid)
      end
      
      free_text_name = element.find_first(product_xpath + "cda:name").try(:text)
      if coded_name
        medication.free_text_brand_name = free_text_name
      end
      
      med_type = element.find_first("cda:entryRelationship[@typeCode='SUBJ']/cda:observation/cda:code/@code").try(:value)
      if med_type
        medication.medication_type = MedicationType.find_by_code(med_type)
      end
      
      exp_date = element.find_first("cda:entryRelationship[@typeCode='REFR']/cda:supply/cda:effectiveTime/@value").try(:value)
      if exp_date
        medication.expiration_time = exp_date.to_s.from_hl7_ts_to_date
      end
      
    end

    medication
  end
end