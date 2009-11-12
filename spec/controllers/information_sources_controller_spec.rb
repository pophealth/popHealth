require File.dirname(__FILE__) + '/../spec_helper'

describe InformationSourcesController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should render edit template on get new" do
    get :new, :patient_id => @patient.id.to_s
    response.should render_template('information_sources/edit')
  end

  it "should assign @information_source on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:information_source].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s
    response.should render_template('information_sources/edit')
  end

  it "should assign @information_source on get edit" do
    get :edit, :patient_id => @patient.id.to_s
    assigns[:information_source].should == @patient.information_source
  end

  it "should render show partial on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('information_sources/_show')
  end

  it "should create information_source on post create" do
    @patient.update_attributes!(:information_source => nil)
    post :create, :patient_id => @patient.id.to_s
    @patient.information_source(true).should_not be_nil
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s
    response.should render_template('information_sources/_show')
  end

  it "should update information_source on put update" do
    old_value = @patient.information_source
    put :update, :patient_id => @patient.id.to_s,
        :information_source => { :organization_name => 'foobar' }
    @patient.information_source(true).organization_name.should == 'foobar'
  end

  it "should render show partial on delete destroy" do
    delete :destroy, :patient_id => @patient.id.to_s
    response.should render_template('information_sources/_show')
  end

  it "should not assign @information_source on delete destroy" do
    delete :destroy, :patient_id => @patient.id.to_s
    assigns[:information_source].should be_nil
  end

  it "should unset @patient.information_source on delete destroy" do
    delete :destroy, :patient_id => @patient.id.to_s
    @patient.information_source(true).should be_nil
  end

end

