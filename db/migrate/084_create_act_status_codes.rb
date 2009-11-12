class CreateActStatusCodes < ActiveRecord::Migration

  def self.up
    create_table :act_status_codes do |t|
      t.string :name
      t.string :code
    end
  end

  def self.down
    drop_table :act_status_codes
  end

end