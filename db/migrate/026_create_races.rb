class CreateRaces < ActiveRecord::Migration
  def self.up
    create_table :races do |t|
      t.string :name
      t.string :code
      t.string :hierarchy
    end
  end

  def self.down
    drop_table :races
  end
end
