class CreateAdverseEventTypes < ActiveRecord::Migration
  def self.up
    create_table :adverse_event_types do |t|
      t.string :name
      t.string :code
      t.string :description
    end
  end

  def self.down
    drop_table :adverse_event_types
  end
end