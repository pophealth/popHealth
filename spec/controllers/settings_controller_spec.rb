require File.dirname(__FILE__) + '/../spec_helper'
describe SettingsController do

  it "should route GET /settings" do
    params_from(:get, '/settings').should == {
      :controller => 'settings',
      :action => 'index'
    }
    route_for(
      :controller => 'settings',
      :action => 'index'
    ).should == '/settings'
  end

  it "should route PUT /settings/1" do
    params_from(:put, '/settings/1').should == {
      :controller => 'settings',
      :action => 'update',
      :id => '1'
    }
  end

  describe "while logged in as a non-admin" do
    before do
      controller.stub!(:current_user).and_return(mock_model(User, :administrator? => false))
    end

    it "should list all settings" do
      Setting.delete_all
      3.times { Setting.factory.create }
      get :index
      assigns(:settings).size.should == 3
    end

    it "should not update a setting" do
      setting = Setting.factory.create(:value => 'foo')
      put :update, :id => setting.id, :setting => { :value => 'bar' }
      response.should redirect_to(root_url)
      flash[:notice].should =~ /not authorized/i
      setting.reload
      setting.value.should == 'foo'
    end
  end

  describe "while logged in as an admin" do
    before do
      controller.stub!(:current_user).and_return(mock_model(User, :administrator? => true))
    end

    it "should update a setting" do
      setting = Setting.factory.create(:value => 'foo')
      put :update, :id => setting.id, :setting => { :value => 'bar' }
      response.should redirect_to(settings_url)
      flash[:notice].should =~ /updated/i
      setting.reload
      setting.value.should == 'bar'
    end
  end
end
