require File.dirname(__FILE__) + '/../spec_helper'

describe PatientsController do

  before(:each) do
    @user = User.factory.create
    controller.stub!(:current_user).and_return(@user)
  end

  it "should create a named template" do
    count = Patient.count
    post :create, :patient => {:name => 'my awesome template'}
    Patient.count.should == count + 1
  end

  it "should not permit creation of a nameless template" do
    post :create, :patient => {:name => ''}
    flash[:notice].should match(/validation failed/i)
    response.should redirect_to patients_url
  end

  it "should return xml content as downloadable" do
    pd_mock = mock('pd')
    pd_mock.stub!(:to_c32).and_return('<ClinicalDocument/>')
    pd_mock.stub!(:test_plan_id).and_return(nil)
    pd_mock.stub!(:id).and_return(7)
    Patient.stub!(:find).and_return(pd_mock)
    get :show, :id => 1, :format => 'xml'
    response.headers['content-type'].should == 'application/x-download'
  end
  
  it "should return xml content with xml declaration" do
    pd_mock = mock('pd')
    pd_mock.should_receive(:to_c32).with(Builder::XmlMarkup.new(:indent => 2).instruct!).and_return("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<ClinicalDocument/>")
    pd_mock.stub!(:test_plan_id).and_return(nil)
    pd_mock.stub!(:id).and_return(1)
    Patient.stub!(:find).and_return(pd_mock)
    get :show, :id => 1, :format => 'xml'
    response.should be_success
  end

  it "should update template name" do
    template = Patient.create!(:name => 'Me', :user => @user)
    put :update, :id => template.id, :patient => { :name => 'You' }
    template.reload
    template.name.should == 'You'
  end

end
