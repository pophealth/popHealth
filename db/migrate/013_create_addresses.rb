class CreateAddresses < ActiveRecord::Migration
  def self.up
    create_table :addresses do |t|
      t.string :street_address_line_one
      t.string :street_address_line_two
      t.string :city
      t.string :state
      t.string :postal_code
      t.belongs_to :iso_country
      t.references :addressable, :polymorphic => true
    end
  end

  def self.down
    drop_table :addresses
  end
end
