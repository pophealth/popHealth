class CreateSnowmedProblems < ActiveRecord::Migration
  
  def self.up
    
    create_table :snowmed_problems do |t|
      t.string  :name
      t.string  :code
    end
    
  end

  def self.down
    drop_table :snowmed_problems
  end
  
end