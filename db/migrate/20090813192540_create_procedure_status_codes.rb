class CreateProcedureStatusCodes < ActiveRecord::Migration
  def self.up
    create_table :procedure_status_codes do |t|
      t.string     :code
      t.string     :description
    end
  end

  def self.down
    drop_table :procedure_status_codes
  end
end
