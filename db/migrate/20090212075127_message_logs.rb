class MessageLogs < ActiveRecord::Migration
  def self.up
    create_table "message_logs", :force => true do |t|
      t.column :message,                  :string,  :limit => 1000
      t.column :created_at,               :datetime
    end
  end

  def self.down
    drop_table "message_logs"
  end
end
