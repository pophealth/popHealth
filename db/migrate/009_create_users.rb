class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :email,                     :string
      t.column :first_name,                :string
      t.column :last_name,                 :string
      t.column :company,                   :string
      t.column :company_url,               :string
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
      t.column :terms_of_service,          :boolean
      t.column :send_updates,              :boolean
      t.column :role_id,                   :integer
      t.column :password_reset_code,       :string, :limit => 40
      t.timestamps
    end
  end

  def self.down
    drop_table "users"
  end
end
