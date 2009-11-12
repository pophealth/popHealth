class LongerErrorMessages < ActiveRecord::Migration
  def self.up
    change_column :content_errors, :error_message, :string, :limit => 2000
  end

  def self.down
    change_column :content_errors, :error_message, :string, :limit => 255
  end
end
