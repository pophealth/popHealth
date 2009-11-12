class CreateTelecoms < ActiveRecord::Migration
  def self.up
    create_table :telecoms do |t|
      t.string :home_phone
      t.string :work_phone
      t.string :mobile_phone
      t.string :vacation_home_phone
      t.string :email
      t.string :url
      # telecomable didn't seem appropriate ;-)
      t.references :reachable, :polymorphic => true
    end
  end

  def self.down
    drop_table :telecoms
  end
end
