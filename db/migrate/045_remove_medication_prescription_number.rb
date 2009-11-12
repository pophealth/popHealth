class RemoveMedicationPrescriptionNumber < ActiveRecord::Migration
  def self.up
    remove_column "medications", "prescription_number"
  end

  def self.down
    add_column "medications", "prescription_number", :string
  end
end