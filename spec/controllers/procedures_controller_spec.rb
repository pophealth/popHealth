require File.dirname(__FILE__) + '/../spec_helper'

describe ProceduresController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should assign @procedure on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:procedure].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.procedures.first.id.to_s
    response.should render_template('procedures/edit')
  end

  it "should assign @procedure on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.procedures.first.id.to_s
    assigns[:procedure].should == @patient.procedures.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('procedures/create')
  end

  it "should assign @procedure on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:procedure].should_not be_new_record
  end

  it "should add an procedure on post create" do
    old_procedure_count = @patient.procedures.count
    post :create, :patient_id => @patient.id.to_s
    @patient.procedures(true).count.should == old_procedure_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.procedures.first.id.to_s
    response.should render_template('procedures/_show')
  end

  it "should update procedure on put update" do
    existing_procedure = @patient.procedures.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_procedure.id.to_s,
      :procedure => { :name => 'foobar' }
    existing_procedure.reload
    existing_procedure.name.should == 'foobar'
  end

  it "should remove from @patient.procedures on delete destroy" do
    existing_procedure = @patient.procedures.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_procedure.id.to_s
    @patient.procedures(true).should_not include(existing_procedure)
  end

end

