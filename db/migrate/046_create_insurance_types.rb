class CreateInsuranceTypes < ActiveRecord::Migration
  def self.up
    create_table :insurance_types do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :insurance_types
  end
end
