class CreateUserRoles < ActiveRecord::Migration
  def self.up
    create_table "user_roles", :force => true do |t|
      t.column :user_id,                      :int
      t.column :role_id,                      :int
    end
  end

  def self.down
    drop_table "user_roles"
  end
end