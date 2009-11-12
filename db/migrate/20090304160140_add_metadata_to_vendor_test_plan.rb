class AddMetadataToVendorTestPlan < ActiveRecord::Migration
  def self.up
    add_column :vendor_test_plans, :metadata, :text
  end

  def self.down
    remove_column :vendor_test_plans, :metadata
  end
end
