require 'spec_helper'

describe MeasuresController do
  before do
    collection_fixtures 'measures'
  end
  
  describe "GET 'definition'" do
    it "should be successful" do
      get :definition, :id => '0013'
      response.should be_success
      assigns(:definition).should_not be_nil
    end
  end
  
end

  
  