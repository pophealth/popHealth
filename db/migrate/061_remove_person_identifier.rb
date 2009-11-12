class RemovePersonIdentifier < ActiveRecord::Migration
  
  def self.up
    remove_column "registration_information", "person_identifier"
  end

  def self.down
    add_column "registration_information", "person_identifier", :string
  end
end