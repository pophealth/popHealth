class RenamePatientDataIdToPatientId < ActiveRecord::Migration
  PATIENT_CHILD_TABLES = %w[
      languages providers medications allergies insurance_providers conditions
      immunizations encounters procedures medical_equipments patient_identifiers
      registration_information supports information_sources advance_directives
      abstract_results
    ]

  def self.up
    PATIENT_CHILD_TABLES.each do |table|
      rename_column table, :patient_data_id, :patient_id
    end
  end

  def self.down
    PATIENT_CHILD_TABLES.each do |table|
      rename_column table, :patient_id, :patient_data_id
    end
  end
end
