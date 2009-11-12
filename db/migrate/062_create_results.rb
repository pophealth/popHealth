class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.string :result_id
      t.date :result_date
      t.string :result_code, :result_code_display_name
      t.string :status_code
      t.string :type
      t.string :value_scalar, :value_unit
      t.belongs_to :code_system
      t.belongs_to :patient_data
    end
  end

  def self.down
    drop_table :results
  end
end
