class CreateAllergies < ActiveRecord::Migration
  def self.up
    create_table :allergies do |t|
      t.date :start_event
      t.date :end_event
      t.belongs_to :adverse_event_type
      t.string :free_text_product
      t.string :product_code
      t.belongs_to :severity_term

      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :allergies
  end
end
