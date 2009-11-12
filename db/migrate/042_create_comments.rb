class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :text
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :comments
  end
end
