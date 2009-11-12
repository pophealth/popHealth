class CreateAllergyTypeCodes < ActiveRecord::Migration
  def self.up
    create_table :allergy_type_codes do |t|
      t.string     :name
      t.string     :code
    end
  end

  def self.down
    drop_table :allergy_type_codes
  end
end