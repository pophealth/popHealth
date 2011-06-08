require 'spec_helper'

describe AdminController do

  describe "GET 'users'" do
    it "should be successful" do
      get 'users'
      response.should be_success
    end
  end

end
