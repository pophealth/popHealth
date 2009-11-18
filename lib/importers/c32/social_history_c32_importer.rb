class SocialHistoryC32Importer 
  extend ImportHelper

  def self.template_id
    '2.16.840.1.113883.10.20.1.15'
  end

  def self.entry_xpath
    "cda:entry/cda:observation[cda:templateId/@root='2.16.840.1.113883.10.20.1.33']"
  end

  def self.import_entry(entry_element)
    social_history = SocialHistory.new
    with_element(entry_element) do |element|
      
      start_event_string = element.find_first("cda:effectiveTime/cda:low/@value").try(:value)
      if start_event_string
        social_history.start_effective_time = start_event_string.to_s.from_hl7_ts_to_date
      end
      
      end_event_string = element.find_first("cda:effectiveTime/cda:high/@value").try(:value)
      if end_event_string
        social_history.end_effective_time = end_event_string.to_s.from_hl7_ts_to_date
      end
      
      sh_code = element.find_first("cda:code/@code").try(:value) 
      if sh_code
        social_history.social_history_type = SocialHistoryType.find_by_code(sh_code)
      end

    end

    social_history
  end
end