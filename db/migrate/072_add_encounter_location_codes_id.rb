class AddEncounterLocationCodesId < ActiveRecord::Migration
  def self.up
    add_column "encounters", "encounter_location_code_id", :integer
  end

  def self.down
    remove_column "encounters", "encounter_location_code_id"
  end
end