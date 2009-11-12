class MakeDocumentTimestampADatetime < ActiveRecord::Migration
  def self.up
    change_column(:registration_information, :document_timestamp, :datetime)
  end

  def self.down
    change_column(:registration_information, :document_timestamp, :date)
  end
end
