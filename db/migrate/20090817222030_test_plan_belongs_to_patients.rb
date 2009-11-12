class TestPlanBelongsToPatients < ActiveRecord::Migration
  def self.up
    add_column :patients, :test_plan_id, :integer
    add_index :patients, :test_plan_id
  end

  def self.down
    remove_column :patients, :test_plan_id
  end
end
