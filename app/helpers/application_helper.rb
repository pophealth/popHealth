module ApplicationHelper
  
  def render_js(options = nil, extra_options = {}, &block)
    escape_javascript(render(options, extra_options, &block))
  end
  
  def numerator_width(numerator, patient_count)
    if numerator
      "#{((numerator / patient_count.to_f) * 100).to_i}%"      
    else
      '33%'
    end
  end
  
  def denominator_width(numerator, denominator, patient_count)
    if numerator && denominator
      "#{(((denominator - numerator)/ patient_count.to_f) * 100).to_i}%"
    else
      '33%'
    end
  end
end
