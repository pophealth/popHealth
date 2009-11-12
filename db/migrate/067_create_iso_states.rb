class CreateIsoStates < ActiveRecord::Migration
  def self.up
    create_table :iso_states do |t|
      t.string :name
      t.string :iso_abbreviation
      t.string :old_format
    end
  end

  def self.down
    drop_table :iso_states
  end
end
