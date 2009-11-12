class CreateEncounterTypes < ActiveRecord::Migration

  def self.up
    create_table :encounter_types do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :encounter_types
  end

end