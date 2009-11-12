class AddSystemMessages < ActiveRecord::Migration
  def self.up
    create_table :system_messages do |t|
      t.column :author_id,    :integer,   :null => false
      t.column :updater_id,   :integer,   :null => true
      t.column :body,         :text,      :null => false
      t.column :created_at,   :timestamp, :null => false
      t.column :updated_at,   :timestamp, :null => false
    end
  end

  def self.down
    drop_table :system_messages
  end
end
