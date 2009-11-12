class AddInsuranceProviderGroupNumber < ActiveRecord::Migration

  def self.up
    add_column "insurance_providers", "group_number", :string
  end

  def self.down
    remove_column "insurance_providers", "group_number"
  end
  
end
