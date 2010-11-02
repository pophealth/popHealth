require 'spec_helper'

describe MeasuresController do
  #render_views
  
  describe "GET 'result'" do
    it "should be successful" do
      get 'result'
      response.should be_success
    end
  end
  
  describe "GET 'definition'" do
    it "should be successful" do
      get 'definition'
      response.should be_success
    end
  end
  
end

  
  