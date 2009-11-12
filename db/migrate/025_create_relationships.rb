class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :relationships
  end
end
