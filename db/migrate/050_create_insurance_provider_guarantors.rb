class CreateInsuranceProviderGuarantors < ActiveRecord::Migration
  def self.up
    create_table :insurance_provider_guarantors do |t|
      t.date :effective_date
      t.belongs_to :insurance_provider, :null => false
    end
  end

  def self.down
    drop_table :insurance_provider_guarantors 
  end
end
