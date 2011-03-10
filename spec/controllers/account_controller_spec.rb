require 'spec_helper'

describe AccountController do
  it "should allow the creation of new accounts" do
    post :create, :user => {:first_name => 'Joe', :last_name => 'Test', 
                            :username => 'joetest', :password => 'sekret',
                            :email => 'joe@test.org'}, 
                  :agree_license => true, :password_confirmation => 'sekret'
    
    assigns(:user).valid?.should be_true
    assigns(:user)._id.should_not be_nil
    
    assigns(:registration_errors).should be_empty
  end
  
  it "should not allow an account to be created if it doesn't have a username" do
    post :create, :user => {:first_name => 'Joe', :last_name => 'Test', 
                            :password => 'sekret', :email => 'joe@test.org'}, 
                  :agree_license => true, :password_confirmation => 'sekret'
    
    assigns(:user).valid?.should be_false
    assigns(:user)._id.should be_nil
    
    assigns(:registration_errors).should_not be_empty
  end
end