class CreateLoincLabCodes < ActiveRecord::Migration

  def self.up
    create_table :loinc_lab_codes do |t|
      t.string :name
      t.text   :description
      t.string :code
      t.timestamps
    end
  end

  def self.down
    drop_table :loinc_codes
  end

end
