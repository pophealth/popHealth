# helper methods for caluclating the various fields for the pophealth dashbard view

module ReportDataCalculator
  
  @@id_arrays = Hash.new
  
  def self.get_bar_length(field, bin, report_array = nil)
    if @@id_arrays.empty?
      update_id_arrays
    end
    
    if report_array == nil
      @@id_arrays[field][bin].size
    else 
      (report_array & @@id_arrays[field][bin]).size
    end
  end
  
  def self.update_id_arrays
    all_fields = FieldConfiguration.find(:all)
    all_fields.each { |field|
      bin_arrays = Array.new 
      0.upto(field.bins.length - 1) { |i|
        bin_arrays[i] = Report.patient_count_with_ids(field.bin_hashes[i]) 
      }
      @@id_arrays[field.symbol] = bin_arrays
    } 
  end
  
  
end