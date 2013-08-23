class Bundle
  include Mongoid::Document

  field :title, type: String
  field :effective_date, type: Integer
  field :version, type: String
  field :license, type: String
  field :measures, type: Array
  field :exported, type: String
  field :extensions, type: Array

end