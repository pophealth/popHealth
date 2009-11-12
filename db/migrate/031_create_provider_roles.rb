class CreateProviderRoles < ActiveRecord::Migration
  def self.up
    create_table :provider_roles do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :provider_roles
  end
end