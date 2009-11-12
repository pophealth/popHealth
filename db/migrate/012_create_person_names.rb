class CreatePersonNames < ActiveRecord::Migration
  def self.up
    create_table :person_names do |t|
      t.string :name_prefix
      t.string :first_name
      t.string :last_name
      t.string :name_suffix
      t.references :nameable, :polymorphic => true
    end
  end

  def self.down
    drop_table :person_names
  end
end
