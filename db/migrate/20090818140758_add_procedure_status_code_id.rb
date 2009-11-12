class AddProcedureStatusCodeId < ActiveRecord::Migration
  def self.up
    add_column "procedures", "procedure_status_code_id", :integer 
  end

  def self.down
    remove_column "procedures", "procedure_status_code_id"
  end
end
