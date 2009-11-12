class AddAdvanceDirectiveStatusCodesId < ActiveRecord::Migration
  def self.up
    add_column "advance_directives", "advance_directive_status_code_id", :integer
  end

  def self.down
    remove_column "advance_directives", "advance_directive_status_code_id"
  end
  
end