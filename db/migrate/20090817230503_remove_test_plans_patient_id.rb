class RemoveTestPlansPatientId < ActiveRecord::Migration
  def self.up
    remove_column :test_plans, :patient_id
  end

  def self.down
    add_column :test_plans, :patient_id, :integer
  end
end
