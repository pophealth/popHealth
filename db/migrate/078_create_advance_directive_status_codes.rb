class CreateAdvanceDirectiveStatusCodes < ActiveRecord::Migration
  def self.up
    create_table :advance_directive_status_codes do |t|
      t.string     :name
      t.string     :code
    end
  end

  def self.down
    drop_table :advance_directive_status_codes
  end
end