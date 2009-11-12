class AddSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
      t.string :name, :null => false
      t.text   :value
    end
    add_index :settings, [ :name ], :unique => true
  end

  def self.down
    drop_table :settings
  end
end
