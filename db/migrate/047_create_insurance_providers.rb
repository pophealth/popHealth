class CreateInsuranceProviders < ActiveRecord::Migration
  def self.up
    create_table :insurance_providers do |t|
      t.string :represented_organization
      t.belongs_to :insurance_type
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :insurance_providers
  end
end
