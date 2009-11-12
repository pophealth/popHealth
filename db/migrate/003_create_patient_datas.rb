class CreatePatientDatas < ActiveRecord::Migration
  def self.up
    create_table :patient_data do |t|
      t.string :name
      t.boolean :pregnant
      t.boolean :no_known_allergies
      t.timestamps
      t.belongs_to :vendor_test_plan
      t.belongs_to :user, :null => false
    end
  end

  def self.down
    drop_table :patient_data
  end
end
