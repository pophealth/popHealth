class AddTableIndices < ActiveRecord::Migration
  def self.up
    add_index :abstract_results, :type
    add_index :abstract_results, :patient_id
    add_index :addresses, [:addressable_id, :addressable_type]
    add_index :advance_directives, :patient_id
    add_index :allergies, :patient_id
    add_index :comments, [:commentable_id, :commentable_type]
    add_index :content_errors, :msg_type
    add_index :encounters, :patient_id
    add_index :immunizations, :patient_id
    add_index :information_sources, :patient_id
    add_index :insurance_provider_guarantors, :insurance_provider_id
    add_index :insurance_provider_patients, :insurance_provider_id
    add_index :insurance_provider_subscribers, :insurance_provider_id
    add_index :insurance_providers, :patient_id
    add_index :languages, :patient_id
    add_index :medical_equipments, :patient_id
    add_index :medications, :patient_id
    add_index :patient_identifiers, :patient_id
    add_index :patients, :user_id
    add_index :person_names, [:nameable_id, :nameable_type]
    add_index :procedures, :patient_id
    add_index :providers, :patient_id
    add_index :registration_information, :patient_id
    add_index :supports, :patient_id
    add_index :telecoms, [:reachable_id, :reachable_type]
    add_index :test_plans, [:user_id, :vendor_id]
    add_index :users, :email, :unique => true
  end

  def self.down
    remove_index :abstract_results, :type
    remove_index :abstract_results, :patient_id
    remove_index :addresses, [:addressable_id, :addressable_type]
    remove_index :advance_directives, :patient_id
    remove_index :allergies, :patient_id
    remove_index :comments, [:commentable_id, :commentable_type]
    remove_index :content_errors, :msg_type
    remove_index :encounters, :patient_id
    remove_index :immunizations, :patient_id
    remove_index :information_sources, :patient_id
    remove_index :insurance_provider_guarantors, :insurance_provider_id
    remove_index :insurance_provider_patients, :insurance_provider_id
    remove_index :insurance_provider_subscribers, :insurance_provider_id
    remove_index :insurance_providers, :patient_id
    remove_index :languages, :patient_id
    remove_index :medical_equipments, :patient_id
    remove_index :medications, :patient_id
    remove_index :patient_identifiers, :patient_id
    remove_index :patients, :user_id
    remove_index :person_names, [:nameable_id, :nameable_type]
    remove_index :procedures, :patient_id
    remove_index :providers, :patient_id
    remove_index :registration_information, :patient_id
    remove_index :supports, :patient_id
    remove_index :telecoms, [:reachable_id, :reachable_type]
    remove_index :test_plans, [:user_id, :vendor_id]
    remove_index :users, :email
  end
end
