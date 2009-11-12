class CreateRegistrationInformations < ActiveRecord::Migration
  def self.up
    create_table :registration_information do |t|
      t.string :person_identifier
      t.date :date_of_birth
      t.belongs_to :religion
      t.belongs_to :marital_status
      t.belongs_to :gender
      t.belongs_to :race
      t.belongs_to :ethnicity
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :registration_information
  end
end
