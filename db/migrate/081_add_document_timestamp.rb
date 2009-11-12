class AddDocumentTimestamp < ActiveRecord::Migration

  def self.up
    add_column "registration_information", "document_timestamp", :date
  end

  def self.down
    remove_column "registration_information", "document_timestamp"
  end

end