require File.dirname(__FILE__) + '/../spec_helper'

describe PatientIdentifiersController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should assign @patient_identifier on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:patient_identifier].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.patient_identifiers.first.id.to_s
    response.should render_template('patient_identifiers/edit')
  end

  it "should assign @patient_identifier on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.patient_identifiers.first.id.to_s
    assigns[:patient_identifier].should == @patient.patient_identifiers.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('patient_identifiers/create')
  end

  it "should assign @patient_identifier on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:patient_identifier].should_not be_new_record
  end

  it "should add an patient_identifier on post create" do
    old_patient_identifier_count = @patient.patient_identifiers.count
    post :create, :patient_id => @patient.id.to_s
    @patient.patient_identifiers(true).count.should == old_patient_identifier_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.patient_identifiers.first.id.to_s
    response.should render_template('patient_identifiers/_show')
  end

  it "should update patient_identifier on put update" do
    existing_patient_identifier = @patient.patient_identifiers.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_patient_identifier.id.to_s,
      :patient_identifier => { :patient_identifier => 'foobar' }
    existing_patient_identifier.reload
    existing_patient_identifier.patient_identifier.should == 'foobar'
  end

  it "should remove from @patient.patient_identifiers on delete destroy" do
    existing_patient_identifier = @patient.patient_identifiers.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_patient_identifier.id.to_s
    @patient.patient_identifiers(true).should_not include(existing_patient_identifier)
  end

end

