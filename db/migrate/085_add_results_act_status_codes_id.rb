class AddResultsActStatusCodesId < ActiveRecord::Migration

  def self.up
    add_column "results", "act_status_code_id", :integer
  end

  def self.down
    remove_column "results", "act_status_code_id"
  end

end