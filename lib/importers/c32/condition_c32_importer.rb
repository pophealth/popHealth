class ConditionC32Importer 
  extend ImportHelper
  
  def self.template_id
    '2.16.840.1.113883.10.20.1.11'
  end
  
  def self.entry_xpath
    "cda:entry/cda:act[cda:templateId/@root='2.16.840.1.113883.10.20.1.27']/cda:entryRelationship[@typeCode='SUBJ']/cda:observation[cda:templateId[@root='2.16.840.1.113883.10.20.1.28']]"
  end
  
  def self.import_entry(entry_element)
    condition = Condition.new
    with_element(entry_element) do |element|
      
      start_event_string = element.find_first("cda:effectiveTime/cda:low/@value")
      if start_event_string
        condition.start_event = start_event_string.to_s.from_hl7_ts_to_date
      end
      
      end_event_string = element.find_first("cda:effectiveTime/cda:high/@value")
      if end_event_string
        condition.end_event = end_event_string.to_s.from_hl7_ts_to_date
      end
      
      condition.free_text_name = "Test Diabetes"
      
      problem_type_code = element.find_first("cda:code/@code")
      
      if problem_type_code
        condition.problem_type = ProblemType.find_by_code(problem_type_code)
      end
    end

    condition
  end


end