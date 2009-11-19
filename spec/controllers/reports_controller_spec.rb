require File.dirname(__FILE__) + '/../spec_helper'

describe ReportsController do
  fixtures :genders, :social_history_types, :patients, :reports
  require 'json'

  before(:each) do
    @user = User.factory.create
    controller.stub!(:current_user).and_return(@user)
  end
  
  it "should list all reports in JSON format" do
    get :index
    assigns[:reports].length.should == 15
    
    json_response = JSON.load(response.body)
    json_response['populationCount'].should == '7'
    json_response['populationName'].should == 'Columbia Road Health Services'
  end
  
  it "should be able to return a report by ID" do
    get :index, :id => reports(:bp1).id
    
    # Make sure we pulled the correct report
    assigns[:report].id.should == reports(:bp1).id

    json_response = JSON.load(response.body)
    json_response['title'].should == 'ABCS: BP Control 1'
    json_response['id'].should == reports(:bp1).id
    json_response['numerator'].should == 0
    json_response['denominator'].should == 0
    json_response['numerator_fields'].keys[0].should == 'blood_pressures'
    json_response['denominator_fields'].keys[0].should == 'hypertension'
    
    # Make sure the other fields aren't nil
    json_response['hypertension'].should_not be_nil
    json_response['medications'].should_not be_nil
    json_response['smoking'].should_not be_nil    
  end
  
  it "should change a report, but not save it, when new parameters are POSTed" do
    report = reports(:bp1)
    
    post :create, :id => report.id, :denominator => {"hypertension"=>["Yes", "No"]}
    
    report.reload
    
    report.denominator_query.should == {:hypertension=>["Yes"], :ischemic_vascular_disease=>["No"], :age=>["18-34", "35-49", "50-64", "65-75", "76+"]}
    
    json_response = JSON.load(response.body)
    
    json_response['denominator_fields'].should == {'hypertension' => ['Yes', 'No']}
    json_response['id'].should == reports(:bp1).id
  end
  
  it "should not create a new report, but should return an empty query, when you POST empty query params with no ID" do
    count = Report.count
    
    post :create, :denominator => {}, :numerator => {}
    
    Report.count.should == count
  end
  
  it "should create and save a new report when you post actual parameters" do
    count = Report.count
    
    post :create, :denominator => {"hypertension" => ["Yes", "No"]}, :numerator => {}
    
    Report.count.should == count + 1
    
    assigns[:report].id.should_not be_nil
    
    JSON.load(response.body)['id'].should == assigns[:report].id
  end
  
  it "should respond with blank numerator and denominator when POSTed with an ID and no numerator or denominator" do
    report = reports(:bp1)
    
    post :create, :id => report.id
    
    report.reload
    
    report.denominator_query.should == {:hypertension=>["Yes"], :ischemic_vascular_disease=>["No"], :age=>["18-34", "35-49", "50-64", "65-75", "76+"]}
    
    json_response = JSON.load(response.body)
    
    json_response['denominator_fields'].should == {}
    json_response['numerator_fields'].should == {}
    json_response['id'].should == reports(:bp1).id
  end

end