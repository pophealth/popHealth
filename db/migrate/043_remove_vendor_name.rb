class RemoveVendorName < ActiveRecord::Migration
  def self.up
    remove_column "vendors", "name"
  end

  def self.down
    add_column "vendors", "name", :string
  end
end