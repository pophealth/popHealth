class CreateReports < ActiveRecord::Migration

  def self.up
    create_table :reports do |t|
      t.string :title
      t.string :numerator_query, :limit => 2000
      t.string :denominator_query, :limit => 2000
      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end

end