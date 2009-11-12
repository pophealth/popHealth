class AddResultsOrganizerId < ActiveRecord::Migration

  def self.up
    add_column "results", "organizer_id", :string
  end

  def self.down
    remove_column "results", "organizer_id"
  end

end