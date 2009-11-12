class CreateVendors < ActiveRecord::Migration
  def self.up
    create_table :vendors do |t|
      t.string :public_id
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :vendors
  end
end
