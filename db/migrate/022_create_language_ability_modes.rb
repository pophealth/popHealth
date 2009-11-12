class CreateLanguageAbilityModes < ActiveRecord::Migration
  def self.up
    create_table :language_ability_modes do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :language_ability_modes
  end
end
