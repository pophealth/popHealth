class CreateIsoCountries < ActiveRecord::Migration
  def self.up
    create_table :iso_countries do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :iso_countries
  end
end
