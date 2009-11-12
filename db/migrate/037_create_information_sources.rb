class CreateInformationSources < ActiveRecord::Migration
  def self.up
    create_table :information_sources do |t|
      t.date :time
      t.string :organization_name
      t.string :document_id
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :information_sources
  end
end
