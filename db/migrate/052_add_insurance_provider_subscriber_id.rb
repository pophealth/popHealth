class AddInsuranceProviderSubscriberId < ActiveRecord::Migration
  def self.up
    add_column "insurance_provider_subscribers", "subscriber_id", :string
  end

  def self.down
    remove_column "insurance_provider_subscribers", "subscriber_id"
  end
end