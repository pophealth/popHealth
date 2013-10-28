module MeasuresHelper
  # Helper for iterating through the sub ids for a measure. For measures that do not have any sub ids
  # this method will loop once passing in nil as a sub id
  def subs_iterator(measure_subs)
    subs = nil
    if measure_subs.empty?
      subs = [nil]
    else
      subs = measure_subs
    end
    subs.each do |sub_id|
      yield sub_id
    end
  end
  
	# added from bstrezze
  # Checks a measure id to see if it is in the Array returned
  # be getting the selected_measure collection
  def measure_selected(measure_id, selected_measures)
    is_selected?(measure_id, selected_measures) ? 'checked' : nil
  end
  
  def display_row(measure_id, selected_measures)
    is_selected?(measure_id, selected_measures) ? "" : "display:none"
  end
  
  def display_header(measures, selected_measures)
    (measures.map { |m| m['id'] } & selected_measures.map { |m| m['id'] }).empty? ? "display:none" : ""
  end
  
  def display_provider(provider, index, page)
     ((page - 1) * 10 <= index) && index < (page * 10) ? "" : "display:none"
  end
  
  def is_selected?(measure_id, selected_measures)
    selected_measures.any? {|measure| measure['id'] == measure_id}
  end
  
  def value_or_default(results, field, default)
    results[field] || default
  end
  
  def percentage(results)
    raw_percentage(value_or_default(results, 'numerator', 0), value_or_default(results, 'denominator', 0))
  end
  
  def display_raw_percentage(numerator, denominator)
    output = raw_percentage(numerator, denominator)
    if output
      "#{output}%"
    end
  end
  
  def raw_percentage(numerator, denominator)
    return unless denominator
    if denominator > 0
      ((numerator / denominator.to_f) * 100).to_i
    else
      0
    end
  end
    
  # def numerator_width(results)
  #     # raise results['numerator'].inspect
  #     if results['numerator']
  #       raise results.inspect
  #       "#{((results['numerator'] / results['patient_count'].to_f) * 100).to_i}%"      
  #     else
  #       '33%'
  #     end
  #   end
  #   
  #   def denominator_width(results)
  #     if results['numerator'] && results['denominator']
  #       "#{(((results['denominator'] - results['numerator'])/ results['patient_count'].to_f) * 100).to_i}%"
  #     else
  #       '33%'
  #     end
  #   end

  def dob(time)
    if time
      Time.at(time).strftime("%m/%d/%Y").to_s
    else 
      nil
    end
  end

  def age_from_time(time)
    if (time)
      t = Time.now.to_i - time
      year = 365 * 24 * 60 * 60
      (t/year).to_i
    else
      nil
    end
  end
  
  def result_hash(measure_id, sub_id, effective_date, filters)
    qr = QME::QualityReport.new(measure_id, sub_id, 'effective_date' => effective_date, 'filters' => filters)
    result = {'patient_count' => @patient_count}
    if qr.calculated?
      result.merge!(qr.result)
    else
      result['uuid'] = qr.calculate
    end
    
    result
  end
  
  def measure_stats_div(measure_id, sub_id, effective_date, filters)
    results = result_hash(measure_id, sub_id, effective_date, filters)
    div_options = {:class => 'tableMeasureCtrl', :"data-measure-id" => measure_id}
    div_options[:"data-measure-sub-id"] = sub_id if sub_id
    div_options[:"data-calculation-job-uuid"] = results['uuid'] if results['uuid']
    content_tag(:div, div_options) do
      yield results
    end
  end
end
