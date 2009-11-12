#
# This module extends ActiveRecord::Base with a class method find_random
# that returns a random entry from the record; used heavily by the 
# randomize methods for auto-creating patient templates
#

module FindRandom
  
  def find_random
    offset = rand(self.count)
    self.find(:first, :offset => offset)
  end
  
end
