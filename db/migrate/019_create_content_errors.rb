class CreateContentErrors < ActiveRecord::Migration
  def self.up
    create_table :content_errors do |t|
      t.string :section
      t.string :subsection
      t.string :field_name
      t.string :error_message
      t.string :location
      t.string :msg_type, :default=>'error'
      t.belongs_to :vendor_test_plan
    end
  end

  def self.down
    drop_table :content_errors
  end
end
