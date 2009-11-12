class CreateImmunizations < ActiveRecord::Migration
	
  def self.up
    create_table   :immunizations do |t|
      t.boolean    :refusal
      t.date       :administration_date
      t.string     :lot_number_text
      t.timestamps
     
      t.belongs_to :vaccine
      t.belongs_to :no_immunization_reason
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :immunizations
  end
  
end