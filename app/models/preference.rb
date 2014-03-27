class Preference
  include Mongoid::Document

  field :selected_measure_ids, type: Array, default: []
  field :mask_phi_data, type: Boolean, default: false
  field :percentage_visuals, type: Boolean, default: true

  belongs_to :user
end
