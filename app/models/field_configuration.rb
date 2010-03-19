class FieldConfiguration < ActiveRecord::Base
  
  def bins
    @bins ||= self[:bins].split(';')
  end
  
  def codes
    @codes ||= self[:codes].split(';')
  end
  
  def bin_hashes
    @bin_hashes ||= bins.map {|bin| {symbol => bin} }
  end
  
  def symbol
    @symbol ||= self[:symbol].intern
  end
  
  def yes_no_bins?
    bins.include? "Yes" || symbol == :smoking
  end
  
  def from_table
    table = self[:ccd_module].downcase 
    if table == "results" || table == "vital signs"
      "abstract_results"
    elsif table == "immunizations"
      "immunizations, vaccines"
    else
      table
    end
  end
  
end
