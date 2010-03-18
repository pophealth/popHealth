# helper methods for caluclating the various fields for the pophealth dashbard view

module ReportDataCalculator
  
  def self.get_bar_length(report_array, field, bin)
    @@id_arrays[field][bin].size
    # (report_array & @@id_arrays[field][bin])
  end
  
  def self.update_id_arrays
    @@id_arrays ||= Hash.new
    all_fields = FieldConfiguration.find(:all)
    all_fields.each { |field|
      bin_arrays = Array.new 
      0.upto(field.bins.length - 1) { |i|
        bin_arrays[i] = count_patients_with_ids(field.bin_hashes[i]) 
      }
      @@id_arrays[field.symbol] = bin_arrays
    } 
  end
  
  def self.patient_count_with_ids(report_hash)
    Array.new (rand(Report.patient_count, "ids"))
    # ActiveRecord::Base.connection.select_values()
  end
  
end