class CreateEncounterLocationCodes < ActiveRecord::Migration
  def self.up
    create_table :encounter_location_codes do |t|
      t.string     :name
      t.string     :code
    end
  end

  def self.down
    drop_table :encounter_location_codes
  end
end
