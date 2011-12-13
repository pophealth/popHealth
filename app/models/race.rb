class Race
  include Mongoid::Document
  
  field :name, type: String
  field :order, type: Integer
  field :codes, type: Array
  
  scope :from_code, ->(code) {where("codes" => code)}
  scope :ordered, order_by([:order, :asc])
  scope :selected, ->(race_ids) { any_in(:_id => race_ids)}
  scope :selected_or_all, ->(race_ids) { race_ids.nil? || race_ids.empty? ? Race.all : Race.selected(race_ids) }
  
end