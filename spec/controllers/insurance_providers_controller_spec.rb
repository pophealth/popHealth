require File.dirname(__FILE__) + '/../spec_helper'

describe InsuranceProvidersController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should update comment record" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.insurance_providers.first.id.to_s,
      :insurance_provider => { :comment_attributes => { :text => 'roberts' } }
    @patient.insurance_providers.first.comment.text.should == 'roberts'
  end

  it "should assign @insurance_provider on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:insurance_provider].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.insurance_providers.first.id.to_s
    response.should render_template('insurance_providers/edit')
  end

  it "should assign @insurance_provider on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.insurance_providers.first.id.to_s
    assigns[:insurance_provider].should == @patient.insurance_providers.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('insurance_providers/create')
  end

  it "should add an insurance_provider on post create" do
    old_insurance_provider_count = @patient.insurance_providers.count
    post :create, :patient_id => @patient.id.to_s
    @patient.insurance_providers(true).count.should == old_insurance_provider_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.insurance_providers.first.id.to_s
    response.should render_template('insurance_providers/_show')
  end

  it "should update insurance_provider on put update" do
    existing_insurance_provider = @patient.insurance_providers.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_insurance_provider.id.to_s,
      :insurance_provider => { :represented_organization => 'foobar' }
    existing_insurance_provider.reload
    existing_insurance_provider.represented_organization.should == 'foobar'
  end

  it "should remove from @patient.insurance_providers on delete destroy" do
    existing_insurance_provider = @patient.insurance_providers.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_insurance_provider.id.to_s
    @patient.insurance_providers(true).should_not include(existing_insurance_provider)
  end

end

