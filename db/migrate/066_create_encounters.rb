class CreateEncounters < ActiveRecord::Migration
	
  def self.up
    create_table   :encounters do |t|
      t.string     :encounter_id
      t.string     :free_text
      t.string     :name
      t.string     :code
      t.date       :encounter_date
      t.timestamps
     
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :encounters
  end
  
end