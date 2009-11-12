class RemoveRoles < ActiveRecord::Migration
  class User < ActiveRecord::Base; end
  class UserRole < ActiveRecord::Base; end
  def self.up
    add_column :users, :admin, :boolean, :default => false
    User.reset_column_information
    User.all.each { |u| u.update_attributes(:admin => true) if UserRole.find_by_user_id(u.id) }
    drop_table :roles
    drop_table :user_roles
  end

  def self.down
    remove_column :users, :admin
    create_table "roles", :force => true do |t|
      t.string "name"
    end
    create_table "user_roles", :force => true do |t|
      t.integer "user_id"
      t.integer "role_id"
    end
  end
end
