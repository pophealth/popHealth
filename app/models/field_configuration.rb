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
  
end
