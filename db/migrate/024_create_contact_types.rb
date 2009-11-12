class CreateContactTypes < ActiveRecord::Migration
  def self.up
    create_table :contact_types do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :contact_types
  end
end
