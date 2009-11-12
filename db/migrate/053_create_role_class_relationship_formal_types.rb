class CreateRoleClassRelationshipFormalTypes < ActiveRecord::Migration

  def self.up
    create_table :role_class_relationship_formal_types do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :role_class_relationship_formal_types
  end
  
end
