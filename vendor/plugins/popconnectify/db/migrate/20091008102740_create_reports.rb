class CreateReports < ActiveRecord::Migration

  def self.up
    create_table :reports do |t|
      t.string :name
      t.string :numerator, :limit => 2000
      t.string :denominator, :limit => 2000
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end

end