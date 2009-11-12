class AddColumnsToTestPlan < ActiveRecord::Migration
  def self.up
    add_column    :test_plans, :clinical_document_id, :integer
    add_column    :test_plans, :patient_id,           :integer, :null => false
    remove_column :test_plans, :user_id
    remove_column :test_plans, :vendor_id
    add_column    :test_plans, :user_id,              :integer, :null => false
    add_column    :test_plans, :vendor_id,            :integer, :null => false
  end

  def self.down
    remove_column :test_plans, :clinical_document_id
    remove_column :test_plans, :patient_id
    remove_column :test_plans, :user_id
    remove_column :test_plans, :vendor_id
    add_column    :test_plans, :user_id,              :integer, :null => true
    add_column    :test_plans, :vendor_id,            :integer, :null => true
  end
end
