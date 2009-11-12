require File.dirname(__FILE__) + '/20090212075127_message_logs'

class RemoveMessageLogs < ActiveRecord::Migration
  def self.up
    MessageLogs.down
  end

  def self.down
    MessageLogs.up
  end
end
