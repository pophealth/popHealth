class VitalSignC32Importer 
  extend ImportHelper

  def self.template_id
    '2.16.840.1.113883.10.20.1.16'
  end

  def self.entry_xpath
    "cda:entry/cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.15']"
  end
  
  def self.entry_organizer_xpath
    "cda:entry/cda:organizer/cda:component/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.31']"
  end

  def self.import_entry(entry_element)
    vital_sign = VitalSign.new
    with_element(entry_element) do |element|

      id_string = element.find_first("cda:id/@root").try(:value)
      if id_string
        vital_sign.result_id = id_string
      end

      date_string = element.find_first("cda:effectiveTime/@value").try(:value)
      if date_string
        vital_sign.result_date = date_string.to_s.from_hl7_ts_to_date
      end

      code = element.find_first("cda:code/@code").try(:value)
      if code
        vital_sign.result_code = code
      end

      name = element.find_first("cda:code/@displayName").try(:value)
      if name
        vital_sign.result_code_display_name = name
      end

      code_system_oid = element.find_first("cda:code/@codeSystem").try(:value)
      if code_system_oid
        vital_sign.code_system = CodeSystem.find_by_code(code_system_oid)
      end

      scalar_value = element.find_first("cda:value/@value").try(:value)
      if scalar_value
        vital_sign.value_scalar = scalar_value
      end

      unit = element.find_first("cda:value/@unit").try(:value)
      if unit
        vital_sign.value_unit = unit
      end  

    end

    vital_sign
  end
end