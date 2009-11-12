class RenameSocialHistoryPatientDataId < ActiveRecord::Migration
  def self.up
    rename_column :social_history, :patient_data_id, :patient_id
  end

  def self.down
    rename_column :social_history, :patient_id, :patient_data_id
  end
end
