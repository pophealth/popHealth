class CreateMedications < ActiveRecord::Migration
  def self.up
    create_table :medications do |t|
      t.string :product_coded_display_name
      t.string :product_code
      t.belongs_to :code_system
      t.string :free_text_brand_name
      t.belongs_to :medication_type
      t.string :status
      t.float  :quantity_ordered_value
      t.string :quantity_ordered_unit
      t.string :prescription_number
      t.date   :expiration_time
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :medications
  end
end
