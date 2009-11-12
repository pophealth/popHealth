class CreateCoverageRoleTypes < ActiveRecord::Migration

  def self.up
    create_table :coverage_role_types do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :coverage_role_types
  end
  
end
