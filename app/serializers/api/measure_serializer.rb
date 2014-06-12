class Api::MeasureSerializer < ActiveModel::Serializer
  attributes :_id, :name, :category, :hqmf_id, :type, :cms_id
end
