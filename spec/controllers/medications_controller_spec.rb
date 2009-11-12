require File.dirname(__FILE__) + '/../spec_helper'

describe MedicationsController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should update comment record" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.medications.first.id.to_s,
      :medication => { :comment_attributes => { :text => 'roberts' } }
    @patient.medications.first.comment.text.should == 'roberts'
  end

  it "should assign @medication on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:medication].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.medications.first.id.to_s
    response.should render_template('medications/edit')
  end

  it "should assign @medication on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.medications.first.id.to_s
    assigns[:medication].should == @patient.medications.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('medications/create')
  end

  it "should assign @medication on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:medication].should_not be_new_record
  end

  it "should add an medication on post create" do
    old_medication_count = @patient.medications.count
    post :create, :patient_id => @patient.id.to_s
    @patient.medications(true).count.should == old_medication_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.medications.first.id.to_s
    response.should render_template('medications/_show')
  end

  it "should update medication on put update" do
    existing_medication = @patient.medications.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_medication.id.to_s,
      :medication => { :free_text_brand_name => 'foobarbaz' }
    existing_medication.reload
    existing_medication.free_text_brand_name.should == 'foobarbaz'
  end

  it "should remove from @patient.medications on delete destroy" do
    existing_medication = @patient.medications.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_medication.id.to_s
    @patient.medications(true).should_not include(existing_medication)
  end

end

