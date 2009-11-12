class AddHealthplanColumn < ActiveRecord::Migration
  def self.up
    add_column :insurance_providers, :health_plan, :string
  end

  def self.down
    remove_column :insurance_providers, :health_plan
  end
end
