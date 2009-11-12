class CreateSocialHistoryTypes < ActiveRecord::Migration
  def self.up
    create_table :social_history_types do |t|
      t.string :name
      t.string :code
      t.string :description
    end
  end

  def self.down
    drop_table :social_history_types
  end
end
