class AddResultTypeCodesId < ActiveRecord::Migration

  def self.up
    add_column "results", "result_type_code_id", :integer
  end

  def self.down
    remove_column "results", "result_type_code_id"
  end

end