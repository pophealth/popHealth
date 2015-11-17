class Bundle
  include Mongoid::Document

  field :title, type: String
  field :effective_date, type: Integer
  field :effective_start_date, type: Integer
  field :version, type: String
  field :license, type: String
  field :measures, type: Array
  field :exported, type: String
  field :extensions, type: Array

  def license
    read_attribute(:license)
      .gsub(/\\("|')/,'\1') # Remove \ characters from in front of ' or " in the bundle.
      .gsub(/\\n|",$/,' ') # Remove \n from printing out and get rid of ", at end of bundle, replace with space.
  end
end