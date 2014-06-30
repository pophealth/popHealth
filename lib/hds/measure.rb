module HealthDataStandards
   module CQM
    class Measure
      include Mongoid::Document
      field :lower_is_better, type: Boolean
    end
  end
end
