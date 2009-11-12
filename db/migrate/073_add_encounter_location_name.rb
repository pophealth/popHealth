class AddEncounterLocationName < ActiveRecord::Migration
  def self.up
    add_column "encounters", "location_name", :string
  end

  def self.down
    remove_column "encounters", "location_name"
  end
end