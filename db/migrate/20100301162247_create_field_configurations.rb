class CreateFieldConfigurations < ActiveRecord::Migration
  def self.up
    create_table :field_configurations do |t|
      t.string :name
      t.string :ccd_module
      t.string :module_field
      t.string :codes
      t.string :bins
      t.string :symbol
    end
  end

  def self.down
    drop_table :field_configurations
  end
end
