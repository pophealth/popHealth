class AddPersonIdentifier < ActiveRecord::Migration

  def self.up
    add_column "registration_information", "person_identifier", :string
  end

  def self.down
    remove_column "registration_information", "person_identifier"
  end

end