require 'spec_helper'

describe LogsController do
  include LoginHelper

  before do
    login
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

end
