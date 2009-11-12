require File.dirname(__FILE__) + '/../spec_helper'

describe InsuranceProviderSubscribersController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s,
      :id => @patient.insurance_provider_subscribers.first.id.to_s
    response.should render_template('insurance_provider_subscribers/edit')
  end

  it "should assign @insurance_provider_subscriber on get edit" do
    get :edit, :patient_id => @patient.id.to_s,
      :id => @patient.insurance_provider_subscribers.first.id.to_s
    assigns[:insurance_provider_subscriber].should == @patient.insurance_provider_subscribers.first
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s,
      :id => @patient.insurance_provider_subscribers.first.id.to_s
    response.should render_template('insurance_provider_subscribers/_show')
  end

  it "should update insurance_provider_subscriber on put update" do
    existing_insurance_provider_subscriber = @patient.insurance_provider_subscribers.first
    put :update, :patient_id => @patient.id.to_s,
      :id => existing_insurance_provider_subscriber.id.to_s,
      :insurance_provider_subscriber => { :subscriber_id => 'foobar' }
    existing_insurance_provider_subscriber.reload
    existing_insurance_provider_subscriber.subscriber_id.should == 'foobar'
  end

end

