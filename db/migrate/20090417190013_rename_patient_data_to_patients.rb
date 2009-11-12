class RenamePatientDataToPatients < ActiveRecord::Migration
  def self.up
    rename_table :patient_data, :patients
  end

  def self.down
    rename_table :patients, :patient_data
  end
end
