class CreateAdvanceDirectives < ActiveRecord::Migration
  def self.up
    create_table :advance_directives do |t|
      t.date :start_effective_time
      t.date :end_effective_time
      t.string :free_text
      t.belongs_to :advance_directive_type
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :advance_directives
  end
end
