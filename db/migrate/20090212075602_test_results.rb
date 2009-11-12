class TestResults < ActiveRecord::Migration
  def self.up
    create_table "test_results", :force => true do |t|
      t.belongs_to :vendor_test_plan,             :null => false
      t.column :assigning_authority,              :string
      t.column :patient_identifier,               :string
      t.column :result,                           :string
    end
  end

  def self.down
    drop_table "test_results"
  end
end
