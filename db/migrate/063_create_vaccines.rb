class CreateVaccines < ActiveRecord::Migration
	
  def self.up
    create_table :vaccines do |t|
      t.string  :name
      t.string  :code
    end
  end

  def self.down
    drop_table :vaccines
  end
  
end
