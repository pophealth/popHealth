class RemoveVendorTestErrors < ActiveRecord::Migration

  def self.up
    remove_column "vendor_test_plans", "errors"
  end

  def self.down
    add_column "vendor_test_plans", "errors", :integer
  end

end
