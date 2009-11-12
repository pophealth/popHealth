class CreateMedicalEquipments < ActiveRecord::Migration
  def self.up
    create_table :medical_equipments do |t|
      t.string     :code
      t.string     :name
      t.string     :supply_id
      t.date       :date_supplied
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :medical_equipments
  end
end
