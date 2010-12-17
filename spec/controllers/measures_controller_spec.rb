require 'spec_helper'

describe MeasuresController do
  before do
    collection_fixtures 'measures', 'selected_measures', 'records'
  end
  
  describe "GET 'definition'" do
    it "should be successful" do
      get :definition, :id => '0013'
      response.should be_success
      assigns(:definition).should_not be_nil
    end
  end
  
  describe "GET 'index'" do
    it "should be successful" do
      get :index
      response.should be_success
      assigns(:patient_count).should == 2
      assigns(:grouped_selected_measures).should have_key("Women's Health")
    end
  end
  
end

  
  