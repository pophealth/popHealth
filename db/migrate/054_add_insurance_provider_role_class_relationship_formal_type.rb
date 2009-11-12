class AddInsuranceProviderRoleClassRelationshipFormalType < ActiveRecord::Migration

  def self.up
    add_column "insurance_providers", "role_class_relationship_formal_type_id", :integer
  end

  def self.down
    remove_column "insurance_providers", "role_class_relationship_formal_type_id"
  end
  
end
