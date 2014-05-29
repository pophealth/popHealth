class Ethnicity
  include Mongoid::Document
  
  field :name, type: String
  field :order, type: Integer
  field :codes, type: Array
  
  scope :from_code, ->(code) {where("codes" => code)}
  scope :ordered, -> { asc(:order) }
  scope :selected, ->(ethnicity_ids) { any_in(:_id => ethnicity_ids)}
  scope :selected_or_all, ->(ethnicity_ids) { ethnicity_ids.nil? || ethnicity_ids.empty? ? Ethnicity.all : Ethnicity.selected(ethnicity_ids) }
  
end