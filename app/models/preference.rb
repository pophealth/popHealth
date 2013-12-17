class Preference
  include Mongoid::Document

  field :selected_measure_ids, type: Array, default: []
  field :mask_phi_data, type: Boolean, default: false

  belongs_to :user
end