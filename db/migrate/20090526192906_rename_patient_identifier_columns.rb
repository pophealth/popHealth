class RenamePatientIdentifierColumns < ActiveRecord::Migration
  def self.up
    rename_column :patient_identifiers, :identifier_domain_identifier, :affinity_domain
  end

  def self.down
    rename_column :patient_identifiers, :affinity_domain, :identifier_domain_identifier
  end
end
