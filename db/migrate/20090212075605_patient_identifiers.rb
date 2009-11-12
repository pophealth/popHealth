class PatientIdentifiers < ActiveRecord::Migration
  def self.up
      create_table "patient_identifiers", :force => true do |t|
      t.belongs_to :patient_data,                 :null => false
      t.column :identifier_domain_identifier,     :string
      t.column :patient_identifier,               :string
    end
  end

  def self.down
    drop_table "patient_identifiers"
  end
end
