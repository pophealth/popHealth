class CreateEthnicities < ActiveRecord::Migration
  def self.up
    create_table :ethnicities do |t|
      t.string :name
      t.string :code
      t.string :hierarchy
    end
  end

  def self.down
    drop_table :ethnicities
  end
end