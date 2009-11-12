require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  describe "with administrator role" do
    before(:each) do
      @user = User.factory.create
      @user.grant_admin
    end

    it "is an administrator" do
      @user.administrator?.should be_true
    end
  end

  describe "without administrator role" do
    before(:each) do
      @user = User.factory.create
      @user.revoke_admin
    end

    it "is not an administrator" do
      @user.administrator?.should be_false
    end
  end
end
