class AddInsuranceProviderCoverageRoleType < ActiveRecord::Migration

  def self.up
    add_column "insurance_providers", "coverage_role_type_id", :integer
  end

  def self.down
    remove_column "insurance_providers", "coverage_role_type_id"
  end
  
end
