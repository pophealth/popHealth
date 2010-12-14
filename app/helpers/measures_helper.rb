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
end
