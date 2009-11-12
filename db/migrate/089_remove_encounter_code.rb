class RemoveEncounterCode < ActiveRecord::Migration
  
  def self.up
    remove_column "encounters", "code"
  end

  def self.down
    add_column "encounters", "code", :string
  end
end