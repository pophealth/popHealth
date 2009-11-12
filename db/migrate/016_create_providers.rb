class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.date :start_service
      t.date :end_service
      t.belongs_to :provider_type
      t.belongs_to :provider_role
      t.string :provider_role_free_text
      t.string :organization
      t.string :patient_identifier
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :providers
  end
end
