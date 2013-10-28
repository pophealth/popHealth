class Language
  include Mongoid::Document
  
  field :name, type: String
  field :order, type: Integer
  field :codes, type: Array
  
  scope :ordered, order_by([:order, :asc])
  scope :selected, ->(language_ids) { any_in(:_id => language_ids)}
  scope :selected_or_all, ->(language_ids) { language_ids.nil? || language_ids.empty? ? Language.all : Language.selected(language_ids) }
  scope :by_code, ->(codes) { any_in(codes: codes)}
end