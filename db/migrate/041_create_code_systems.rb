class CreateCodeSystems < ActiveRecord::Migration
  def self.up
    create_table :code_systems do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :code_systems
  end
end
