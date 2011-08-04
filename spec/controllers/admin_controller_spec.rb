require 'spec_helper'

describe AdminController do
  include LoginHelper
  
  before do
    collection_fixtures 'users'
    login
  end

  describe "GET 'users'" do
    it "should be successful" do
      get 'users'
      response.should be_success
    end
  end
  
  describe "POST 'demote'" do
    it "should be successful" do
      post 'demote', :username => 'test@test.org'
      response.should be_success
      u = User.first(:conditions => {:username => 'test@test.org'})
      u.admin?.should be_false
    end
  end

end
