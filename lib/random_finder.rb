# This module extends ActiveRecord::Base#find by permitting the user to
# efficiently select a random record.
#
#  class MyModel < ActiveRecord::Base
#    extend RandomFinder
#  end
#  random_instance = MyModel.find :random
#
# If there are no records from which to select, nil is returned.
#
# Currently it's not possible to pass other options when finding a random
# instance.
module RandomFinder
  def find *args
    if args == [:random]
      first :offset => rand(count)
    else
      super
    end
  end
end
