require File.dirname(__FILE__) + '/../spec_helper'

shared_examples_for "all news users" do
  it "should load the index" do
    get :index
    response.should render_template('news/index')
  end
end

describe NewsController do
  fixtures :settings

  describe "in use by a non-admin" do
    before(:each) do
      @admin = User.factory.create
      @admin.grant_admin
      @user = User.factory.create
      @user.revoke_admin
      controller.stub!(:current_user).and_return(@user)
    end

    it_should_behave_like "all news users"

    it "should not create a new post" do
      count = SystemMessage.count
      post :create, :message => {:body => 'hi world'}
      SystemMessage.count.should == count
    end

    it "should not update existing news" do
      msg = SystemMessage.create!(:body => 'hi world', :author => @admin)
      put :update, :id => msg.id, :message => {:body => 'hi there'}
      msg.reload
      msg.body.should == 'hi world'
    end

    it "should not delete existing news" do
      msg = SystemMessage.create!(:body => 'hi world', :author => @admin)
      delete :destroy, :id => msg.id
      lambda { msg.reload }.should_not raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "in use by an admin" do
    before(:each) do
      @admin = User.factory.create
      @admin.grant_admin
      @user = User.factory.create
      @user.grant_admin
      controller.stub!(:current_user).and_return(@user)
    end

    it_should_behave_like "all news users"

    it "should display the new message template" do
      get :new
      assigns[:message].should_not be_nil
      response.should render_template('news/new')
    end

    it "should display the edit message template" do
      msg = SystemMessage.create!(:body => 'hi world', :author => @admin)
      get :edit, :id => msg.id
      assert_equal assigns[:message], msg
      response.should render_template('news/edit')
    end

    it "should create a new post" do
      count = SystemMessage.count
      post :create, :message => {:body => 'hi world'}
      response.should redirect_to(:action => 'index')
      SystemMessage.count.should == count + 1
    end

    it "should fail and redisplay on create with invalid input" do
      count = SystemMessage.count
      post :create, :message => {:body => ''}
      response.should be_success
      SystemMessage.count.should == count
    end

    it "should update existing news" do
      msg = SystemMessage.create!(:body => 'hi world', :author => @user)
      put :update, :id => msg.id, :message => {:body => 'hi there'}
      response.should redirect_to(:action => 'index')
      msg.reload
      msg.body.should == 'hi there'
    end

    it "should fail and redisplay on update with invalid input" do
      msg = SystemMessage.create!(:body => 'hi world', :author => @user)
      put :update, :id => msg.id, :message => {:body => ''}
      response.should be_success
      msg.reload
      msg.body.should == 'hi world'
    end

    it "should delete existing news" do
      msg = SystemMessage.create!(:body => 'hi world', :author => @user)
      delete :destroy, :id => msg.id
      response.should redirect_to(:action => 'index')
      lambda { msg.reload }.should raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
