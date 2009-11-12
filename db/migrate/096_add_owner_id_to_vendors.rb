class AddOwnerIdToVendors < ActiveRecord::Migration
  def self.up
    add_column :vendors, :user_id, :integer
    add_index :vendors, :user_id
  end
  def self.down
    remove_column :vendors, :user_id
  end
end
