class RenameResultsToAbstractResults < ActiveRecord::Migration
  def self.up
    rename_table :results, :abstract_results
  end

  def self.down
    rename_table :abstract_results, :results
  end
end
