require File.dirname(__FILE__) + '/../spec_helper'

describe SupportsController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should render edit template on get new" do
    get :new, :patient_id => @patient.id.to_s
    response.should render_template('supports/edit')
  end

  it "should assign @support on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:support].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s
    response.should render_template('supports/edit')
  end

  it "should assign @support on get edit" do
    get :edit, :patient_id => @patient.id.to_s
    assigns[:support].should == @patient.support
  end

  it "should render show partial on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('supports/_show')
  end

  it "should create support on post create" do
    @patient.update_attributes!(:support => nil)
    post :create, :patient_id => @patient.id.to_s
    @patient.support(true).should_not be_nil
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s
    response.should render_template('supports/_show')
  end

  it "should update support on put update" do
    old_value = @patient.support
    put :update, :patient_id => @patient.id.to_s,
        :support => { :name => 'foobar' }
    @patient.support(true).name.should == 'foobar'
  end

  it "should render show partial on delete destroy" do
    delete :destroy, :patient_id => @patient.id.to_s
    response.should render_template('supports/_show')
  end

  it "should not assign @support on delete destroy" do
    delete :destroy, :patient_id => @patient.id.to_s
    assigns[:support].should be_nil
  end

  it "should unset @patient.support on delete destroy" do
    delete :destroy, :patient_id => @patient.id.to_s
    @patient.reload
    @patient.support.should be_nil
  end

end

