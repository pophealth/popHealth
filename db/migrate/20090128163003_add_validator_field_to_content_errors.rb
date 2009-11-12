class AddValidatorFieldToContentErrors < ActiveRecord::Migration
  def self.up
    add_column :content_errors, :validator, :string, :null=>false
    add_column :content_errors, :inspection_type, :string
  end

  def self.down
    remove_column :content_errors, :validator
    remove_column :content_errors, :inspection_type
  end
end
