class RemoveVendorTestPlanAndRelated < ActiveRecord::Migration
  def self.up
    drop_table :vendor_test_plans
    drop_table :kinds
    drop_table :test_results

    remove_column :patients, :vendor_test_plan_id
    remove_column :clinical_documents, :vendor_test_plan_id
    remove_column :content_errors, :vendor_test_plan_id
  end

  def self.down
    add_column :patients, :vendor_test_plan_id, :integer
    add_column :clinical_documents, :vendor_test_plan_id, :integer
    add_column :content_errors, :vendor_test_plan_id, :integer

    create_table "test_results", :force => true do |t|
      t.integer "vendor_test_plan_id", :null => false
      t.string  "assigning_authority"
      t.string  "patient_identifier"
      t.string  "result"
    end
    create_table "vendor_test_plans", :force => true do |t|
      t.integer  "vendor_id"
      t.integer  "kind_id"
      t.integer  "user_id"
      t.float    "compliance"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.text     "metadata"
    end
    create_table "kinds", :force => true do |t|
      t.string "name"
      t.string "test_type"
    end
    add_index "kinds", ["name", "test_type"], :name => "index_kinds_on_test_type_and_name", :unique => true
  end
end
