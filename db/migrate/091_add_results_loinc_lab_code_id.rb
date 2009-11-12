class AddResultsLoincLabCodeId < ActiveRecord::Migration

  def self.up
    add_column "results", "loinc_lab_code_id", :integer
  end

  def self.down
    remove_column "results", "loinc_lab_code_id"
  end
  
end
