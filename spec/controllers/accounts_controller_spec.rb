require 'spec_helper'

describe AccountsController do
  describe 'when creating accounts' do
    it "should allow for new accounts without email verification" do
      EMAIL_VERIFICATION = false
      controller.should_receive(:user=)
      post :create, :user => {:first_name => 'Joe', :last_name => 'Test', 
                              :username => 'joetest', :password => 'sekret',
                              :email => 'joe@test.org'}, 
                    :agree_license => true, :password_confirmation => 'sekret'

      assigns(:user).valid?.should be_true
      assigns(:user)._id.should_not be_nil
      assigns(:user).validation_key.should be_nil

      assigns(:registration_errors).should be_empty
    end

    it "should allow for new accounts with email verification" do
      EMAIL_VERIFICATION = true
      post :create, :user => {:first_name => 'Joe', :last_name => 'Test', 
                              :username => 'joetest2', :password => 'sekret',
                              :email => 'joe2@test.org'}, 
                    :agree_license => true, :password_confirmation => 'sekret'

      assigns(:user).valid?.should be_true
      assigns(:user)._id.should_not be_nil
      assigns(:user).validation_key.should_not be_nil

      assigns(:registration_errors).should be_empty
    end

    it "should not allow submissions without a username" do
      post :create, :user => {:first_name => 'Joe', :last_name => 'Test', 
                              :password => 'sekret', :email => 'joe@test.org'}, 
                    :agree_license => true, :password_confirmation => 'sekret'

      assigns(:user).valid?.should be_false
      assigns(:user)._id.should be_nil

      assigns(:registration_errors).should_not be_empty
    end
  end

  describe 'when logging in' do
    before do
      collection_fixtures 'users'
      @strategy = Warden::Strategies[:my_strategy]
      @user = nil
    end
    
    it "should allow a user to log in without verification when turned off" do
      EMAIL_VERIFICATION = false
      controller.stub(:authenticate!) do
        s = @strategy.new(request.env)
        s.authenticate!
        @user = s.user
      end
      
      controller.stub(:logged_in?) {@user}
      post :login, :username => 'unverified_guy', :password => 'password'
      response.should redirect_to '/'
    end
    
    it "shouldn't allow a user to log in when verification is turned on and not verified" do
      EMAIL_VERIFICATION = true
      controller.stub(:authenticate!) do
        s = @strategy.new(request.env)
        s.stub(:errors) do 
          m = mock('errors')
          m.should_receive(:add).with(:login, "Please check your email to verify this account")
          m
        end
        s.authenticate!
        @user = s.user
      end
      controller.stub(:errors) {mock('errors').should_receive(:add)}
      controller.stub(:logged_in?) {@user}
      post :login, :username => 'unverified_guy', :password => 'password'
    end
    
    it "should allow an account to be verified" do
      controller.should_receive(:user=)
      get :verify, :email => 'unverified_guy@test.org', :validation_key => '12345'
      response.should redirect_to '/'
    end
    
    it "should reject bad verifications" do
      get :verify, :email => 'unverified_guy@test.org', :validation_key => 'not correct'
      response.status.should == 403
    end
  end
  
  describe 'when a password is forgotten' do
    before do
      collection_fixtures 'users'
    end
    
    it "should send an email for a user that has forgotten a password" do
      post :reset_password, :email => "test@test.org"
      response.should be_success
      assigns(:user).reset_key.should_not be_nil
    end
    
    it "should alert a user when an email address is not found" do
      post :reset_password, :email => "db@cooper.org"
      flash[:error].should == "Unable to find an account with that email address"
    end
    
    it "should allow a password to be reset" do
      controller.should_receive(:user=)
      get :password_reset_login, :email => 'forgetful_guy@test.org', :reset_key => '12345'
      assigns(:user).first_name.should == 'Forgetful'
      assigns(:user).reset_key.should be_nil
      response.should be_success
    end
    
    it "should reject bad reset attempts" do
      get :password_reset_login, :email => 'hax0r@70774lyl33t.org', :reset_key => 'sekret!'
      response.status.should == 403
    end
  end
end