class EncounterLocationCode < ActiveRecord::Base
  extend RandomFinder
  has_select_options
end
