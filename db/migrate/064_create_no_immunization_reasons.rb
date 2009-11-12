class CreateNoImmunizationReasons < ActiveRecord::Migration
	
  def self.up
    create_table :no_immunization_reasons do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :no_immunization_reasons
  end
  
end