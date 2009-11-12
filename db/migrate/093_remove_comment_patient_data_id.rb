class RemoveCommentPatientDataId < ActiveRecord::Migration

  def self.up
    remove_column "comments", "patient_data_id"
  end

  def self.down
    add_column "comments", "patient_data_id", :integer
  end

end
