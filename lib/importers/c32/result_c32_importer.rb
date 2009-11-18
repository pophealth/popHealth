class ResultC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.14'
  end
  
  def self.entry_xpath
    "cda:entry/cda:observation[cda:templateId/@root='2.16.840.1.113883.3.88.11.32.16']"
  end
  
  def self.import_entry(entry_element)
    result = Result.new
    with_element(entry_element) do |element|
    
      id_string = element.find_first("cda:id/@root").try(:value)
      if id_string
        result.result_id = id_string
      end
      
      date_string = element.find_first("cda:effectiveTime/@value").try(:value)
      if date_string
        result.result_date = date_string.to_s.from_hl7_ts_to_date
      end
      
      code = element.find_first("cda:code/@code").try(:value)
      if code
        result.result_code = code
      end
      
      name = element.find_first("cda:code/@displayName").try(:value)
      if name
        result.result_code_display_name = name
      end
      
      code_system_oid = element.find_first("cda:code/@codeSystem").try(:value)
      if code_system_oid
        result.code_system = CodeSystem.find_by_code(code_system_oid)
      end
      
      scalar_value = element.find_first("cda:value/@value").try(:value)
      if scalar_value
        result.value_scalar = scalar_value
      end
      
      unit = element.find_first("cda:value/@unit").try(:value)
      if unit
        result.value_unit = unit
      end
      
    end

    result
  end
end