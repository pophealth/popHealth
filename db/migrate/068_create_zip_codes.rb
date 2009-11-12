class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.string :zip
      t.string :state
      t.string :lat
      t.string :long
      t.string :town
    end
  end

  def self.down
    drop_table :zip_codes
  end
end
