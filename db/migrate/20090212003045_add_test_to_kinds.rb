class AddTestToKinds < ActiveRecord::Migration
  def self.up
    add_column :kinds, :test_type, :string
    execute %{ UPDATE kinds SET test_type = 'C32' }
    add_index :kinds, [:test_type, :name], :unique => true
  end

  def self.down
    remove_index :kinds, [:test_type, :name]
    execute %{ DELETE FROM kinds WHERE test_type != 'C32' }
    remove_column :kinds, :test_type
  end
end
