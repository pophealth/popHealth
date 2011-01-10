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
  
  # Checks a measure id to see if it is in the Array returned
  # be getting the selected_measure collection
  def measure_selected(measure_id, selected_measures)
    if selected_measures.any? {|measure| measure['id'] == measure_id}
      'checked'
    else
      nil
    end
  end
  
  def value_or_default(measure_id, sub_id, results, field, default)
    real_id_or_default(measure_id, sub_id, results, default) do |result|
      result[field]
    end
  end
  
  def percentage(measure_id, sub_id, results)
    real_id_or_default(measure_id, sub_id, results, 0) do |result|
      if result[:denominator] > 0
        ((result[:numerator] / result[:denominator].to_f) * 100).to_i
      else
        0
      end
    end
  end
    
  def numerator_width(measure_id, sub_id, results)
    real_id_or_default(measure_id, sub_id, results, '33%') do |result|
      "#{((result[:numerator] / results[:patient_count].to_f) * 100).to_i}%"
    end
  end
  
  def denominator_width(measure_id, sub_id, results)
    real_id_or_default(measure_id, sub_id, results, '33%') do |result|
      "#{(((result[:denominator] - result[:numerator])/ results[:patient_count].to_f) * 100).to_i}%"
    end
  end
  
  
  def dob(time)
    if time
      Time.at(time).to_s 
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
  
  private
  
  def real_id_or_default(measure_id, sub_id, results, default)
    real_measure_id = measure_id
    if sub_id
      real_measure_id += sub_id
    end
    
    if results[real_measure_id]
      yield results[real_measure_id]
    else
      default
    end
  end
end
