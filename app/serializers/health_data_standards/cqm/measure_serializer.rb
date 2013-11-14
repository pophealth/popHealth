module HealthDataStandards
  module CQM
    class MeasureSerializer < ActiveModel::Serializer
      attributes :_id, :name, :category
    end
  end
end
