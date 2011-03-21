require 'spec_helper'

describe MeasuresController do
  
  def mock_user
    @mock_user ||= mock_model('Users', :username => "andy")
  end
  
  def login
     request.env['warden'] = mock(Warden, :authenticate => mock_user,
                                          :authenticate! => mock_user,
                                          :user => mock_user)
  end
  
  before do
    collection_fixtures 'measures', 'selected_measures', 'records'
    login
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

  
  