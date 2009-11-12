require File.dirname(__FILE__) + '/../spec_helper'

describe VendorsController do
  describe "logged-in users" do
    before(:each) do
      @user = User.factory.create
      controller.stub!(:current_user).and_return(@user)
    end

    it "permits creation of new vendors" do
      count = Vendor.count
      post :create, :vendor => { :public_id => 'BARFOO'}
      Vendor.count.should == count + 1
    end

    it "permits deletion of owned vendors" do
      vendor = Vendor.factory.create(:user => @user)
      vendor.editable_by?(@user).should be_true
      delete :destroy, :id => vendor.id.to_s
      lambda { vendor.reload }.should raise_error(ActiveRecord::RecordNotFound)
    end

    it "does not permit renaming of other users' vendors" do
      vendor = Vendor.factory.create(:public_id => 'SOMETHING')
      put :update, :id => vendor.id, :vendor => { :public_id => 'BADIDEA' }
      vendor.reload
      vendor.public_id.should == 'SOMETHING'
    end

    it "does not permit deletion of other users' vendors" do
      vendor = Vendor.factory.create(:public_id => 'SOMETHING')
      delete :destroy, :id => vendor.id.to_s
      lambda { vendor.reload }.should_not raise_error(ActiveRecord::RecordNotFound)
    end

  end
end
