class AddEncounterTypeId < ActiveRecord::Migration

  def self.up
    add_column "encounters", "encounter_type_id", :integer
  end

  def self.down
    remove_column "encounters", "encounter_type_id"
  end

end