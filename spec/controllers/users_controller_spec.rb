require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  describe "handling GET /users/1/edit" do

    before(:each) do
      @user = mock_model(User, :administrator? => false, :display_name => 'Alf', :vendors => [])
      User.stub!(:find).and_return(@user)
      controller.stub!(:current_user).and_return(@user)
    end
  
    it "should be successful" do
      get :edit, :id => "1"
      response.should be_success
    end
  
    it "should render edit template" do
      get :edit, :id => "1"
      response.should render_template('edit')
    end
  
    it "should assign the found User for the view" do
      get :edit, :id => "1"
      assigns[:user].should equal(@user)
    end
  end

  describe "handling PUT /users/1" do

    before(:each) do
      @user = mock_model(User, :to_param => "1", :administrator? => false, :vendors => [], :update_attributes => true)
      User.stub!(:find).and_return(@user)
      controller.stub!(:current_user).and_return(@user)
    end
    
    describe "with successful update" do

      it "should update the found user" do
        put :update, :id => "1", :user => {:first_name => 'Alex'}
        assigns(:user).should equal(@user)
      end

      it "should assign the found user for the view" do
        put :update, :id => "1", :user => {:first_name => 'Alex'}
        assigns(:user).should equal(@user)
      end

      it "should redirect to the user" do
        put :update, :id => "1", :user => {:first_name => 'Alex'}
        response.should redirect_to(edit_user_url("1"))
      end

    end

    describe "with changing the password" do
        
      it "should update the user" do
        put :update, :id => "1", :user => {:password => '123456', :password_confirmation => '123456'}
        assigns(:user).should equal(@user)
      end

    end
    
    describe "with failed update" do

      it "should re-render 'edit'" do
        @user.should_receive(:update_attributes).and_return(false)
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

end
