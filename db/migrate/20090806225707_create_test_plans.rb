class CreateTestPlans < ActiveRecord::Migration
  def self.up
    create_table :test_plans do |t|
      t.string     :type
      t.string     :state
      t.text       :test_type_data
      t.timestamps
      t.references :user
      t.references :vendor
    end
    add_index :test_plans, :user_id
    add_index :test_plans, :vendor_id
  end

  def self.down
    drop_table :test_plans
  end
end
