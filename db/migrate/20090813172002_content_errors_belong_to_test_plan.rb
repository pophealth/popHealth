class ContentErrorsBelongToTestPlan < ActiveRecord::Migration
  def self.up
    add_column :content_errors, :test_plan_id, :integer
    add_index :content_errors, :test_plan_id
  end

  def self.down
    remove_column :content_errors, :test_plan_id
  end
end
