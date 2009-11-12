class CreateSeverityTerms < ActiveRecord::Migration
  def self.up
    create_table :severity_terms do |t|
      t.string  :name
      t.string  :code
      t.integer :scale
    end
  end

  def self.down
    drop_table :severity_terms
  end
end