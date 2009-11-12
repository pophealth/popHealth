class CreateConditions < ActiveRecord::Migration
  def self.up
    create_table :conditions do |t|
      t.date :start_event
      t.date :end_event
      t.belongs_to :problem_type
      t.string :free_text_name
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :conditions
  end
end
