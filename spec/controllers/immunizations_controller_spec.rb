require File.dirname(__FILE__) + '/../spec_helper'

describe ImmunizationsController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should update comment record" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.immunizations.first.id.to_s,
      :immunization => { :comment_attributes => { :text => 'roberts' } }
    @patient.immunizations.first.comment.text.should == 'roberts'
  end

  it "should assign @immunization on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:immunization].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.immunizations.first.id.to_s
    response.should render_template('immunizations/edit')
  end

  it "should assign @immunization on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.immunizations.first.id.to_s
    assigns[:immunization].should == @patient.immunizations.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('immunizations/create')
  end

  it "should assign @immunization on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:immunization].should_not be_new_record
  end

  it "should add an immunization on post create" do
    old_immunization_count = @patient.immunizations.count
    post :create, :patient_id => @patient.id.to_s
    @patient.immunizations(true).count.should == old_immunization_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.immunizations.first.id.to_s
    response.should render_template('immunizations/_show')
  end

  it "should update immunization on put update" do
    existing_immunization = @patient.immunizations.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_immunization.id.to_s,
      :immunization => { :lot_number_text => 'foobar' }
    existing_immunization.reload
    existing_immunization.lot_number_text.should == 'foobar'
  end

  it "should remove from @patient.immunizations on delete destroy" do
    existing_immunization = @patient.immunizations.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_immunization.id.to_s
    @patient.immunizations(true).should_not include(existing_immunization)
  end

end

