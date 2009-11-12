class CreateSocialHistory < ActiveRecord::Migration
  def self.up
    create_table :social_history do |t|      
      t.date :start_effective_time
      t.date :end_effective_time 
      t.belongs_to :social_history_type
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :social_history
  end
end