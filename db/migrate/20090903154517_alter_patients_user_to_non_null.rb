class AlterPatientsUserToNonNull < ActiveRecord::Migration
  def self.up
    remove_column :patients, :user_id
    add_column :patients, :user_id, :integer
  end

  def self.down
    # no-op
  end
end
