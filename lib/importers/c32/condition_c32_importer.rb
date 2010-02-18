class ConditionC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.11'
  end
  
  def self.entry_xpath
    "cda:entry/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']"
  end
  
  def self.import_entry(entry_element)
    condition = Condition.new
    with_element(entry_element) do |element|
      
      start_event_string = element.find_first("cda:effectiveTime/cda:low/@value").try(:value)
      if start_event_string
        condition.start_event = start_event_string.to_s.from_hl7_ts_to_date
      end
      
      end_event_string = element.find_first("cda:effectiveTime/cda:high/@value").try(:value)
      if end_event_string
        condition.end_event = end_event_string.to_s.from_hl7_ts_to_date
      end
      
      obs_xpath = "cda:entryRelationship[@typeCode='SUBJ']/cda:observation[cda:templateId[@root='2.16.840.1.113883.10.20.1.28']]/"
      coded_name = element.find_first(obs_xpath + "cda:value/@displayName").try(:value)
      if coded_name  
        condition.free_text_name = coded_name
      else
        text_name = deref(element.find_first(obs_xpath + "cda:text"))
        if text_name
          condition.free_text_name = text_name
        end
      end
      
      problem_type_code = element.find_first(obs_xpath + "cda:code/@code").try(:value)
      if problem_type_code
        condition.problem_type = ProblemType.find_by_code(problem_type_code)
      end
      
    end

    condition
  end


end