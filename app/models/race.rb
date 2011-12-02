class Race
  include Mongoid::Document
  
  field :name, type: String
  field :order, type: Integer
  field :race, type: Hash
  field :ethnicity, type: Hash
  
  scope :ordered, order_by([:order, :asc])
  scope :selected, ->(race_ids) { any_in(:_id => race_ids)}
  scope :selected_or_all, ->(race_ids) { race_ids.nil? || race_ids.empty? ? Race.all : Race.selected(race_ids) }
  
  
  def flatten(type)
    case type
    when :race
      return race['codes']
    when :ethnicity
      return ethnicity['codes']
    end
  end
end