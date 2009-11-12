class AddInsuranceProviderPatientIdDates < ActiveRecord::Migration
  def self.up
    add_column "insurance_provider_patients", "member_id", :string
    add_column "insurance_provider_patients", "start_coverage_date", :date
    add_column "insurance_provider_patients", "end_coverage_date", :date
  end

  def self.down
    remove_column "insurance_provider_patients", "member_id"
    remove_column "insurance_provider_patients", "start_coverage_date"
    remove_column "insurance_provider_patients", "end_coverage_date"
  end
end
