class RegistrationInfoUpdatePersonId < ActiveRecord::Migration
  def self.up
    remove_column :registration_information, :person_identifier
    add_column :registration_information, :affinity_domain_id, :integer
  end

  def self.down
    remove_column :registration_information, :affinity_domain_id
    add_column :registration_information, :person_identifier, :string
  end
end
