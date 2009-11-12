class AddAssigningAuthorityGuidToInsuranceProviderSubscribers < ActiveRecord::Migration
  def self.up
    add_column :insurance_provider_subscribers, :assigning_authority_guid, :string
  end

  def self.down
    remove_column :insurance_provider_subscribers, :assigning_authority_guid
  end
end
