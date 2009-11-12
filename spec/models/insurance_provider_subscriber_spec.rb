require File.dirname(__FILE__) + '/../spec_helper'

describe InsuranceProviderSubscriber do
  describe "with patients parent record" do
    fixtures :patients, :insurance_providers, :insurance_provider_subscribers
    before do
      @parent = patients(:joe_smith)
    end

    it "should update timestamp of parent on save" do
      old_stamp = @parent.updated_at
      @parent.insurance_provider_subscribers.first.save
      @parent.reload
      @parent.updated_at.should > old_stamp
    end
  end
end
