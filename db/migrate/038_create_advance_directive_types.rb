class CreateAdvanceDirectiveTypes < ActiveRecord::Migration
  def self.up
    create_table :advance_directive_types do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :advance_directive_types
  end
end
