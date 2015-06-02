module ApplicationHelper
  
  def render_js(options = nil, extra_options = {}, &block)
    escape_javascript(render(options, extra_options, &block))
  end
  
  def numerator_width(numerator, patient_count)
    if numerator && !patient_count.zero?
      "#{((numerator / patient_count.to_f) * 100).to_i}%"      
    else
      '0%'
    end
  end
  
  def denominator_width(numerator, denominator, patient_count)
    if numerator && denominator && !patient_count.zero?
      "#{(((denominator - numerator)/ patient_count.to_f) * 100).to_i}%"
    else
      '0%'
    end
  end
  
  def exclusion_width(exclusion, patient_count)
    if exclusion && !patient_count.zero?
      "#{((exclusion / patient_count.to_f) * 100).to_i}%"      
    else
      '0%'
    end
  end
  
  def display_time(seconds_since_epoch)
    Time.at(seconds_since_epoch).strftime('%m/%d/%Y')
  end
   
  def get_practice_parameter(practice_id, practice_name)
    if practice_id
      practice = practice_id
    elsif practice_name
      ext = Practice.where(name: practice_name).first
      practice =  ext.try(:_id).to_s
    else
      practice = nil
    end
    return practice
  end
end
