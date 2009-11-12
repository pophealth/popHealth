class AddAllergyTypeCodesId < ActiveRecord::Migration
  def self.up
    add_column "allergies", "allergy_type_code_id", :integer
  end

  def self.down
    remove_column "allergies", "allergy_type_code_id"
  end
end