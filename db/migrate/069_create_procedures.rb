class CreateProcedures < ActiveRecord::Migration
  def self.up
    create_table :procedures do |t|
      t.string     :procedure_id
      t.string     :name
      t.string     :code
      t.date       :procedure_date
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :procedures
  end
end
