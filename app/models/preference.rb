class Preference
  include Mongoid::Document

  field :selected_measure_ids, type: Array, default: []
  field :mask_phi_data, type: Boolean, default: false
  field :should_display_circle_visual, type: Boolean, default: true
  field :population_chart_scaled_to_IPP, type: Boolean, default: true
  field :show_aggregate_result, type: Boolean, default: false
  field :should_display_provider_tree, type: Boolean, default: false
  
  belongs_to :user
end
