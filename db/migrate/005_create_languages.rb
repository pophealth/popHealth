class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.belongs_to :iso_language
      t.belongs_to :iso_country
      t.belongs_to :language_ability_mode
      t.boolean :preference
      t.belongs_to :patient_data, :null => false
    end
  end

  def self.down
    drop_table :languages
  end
end
