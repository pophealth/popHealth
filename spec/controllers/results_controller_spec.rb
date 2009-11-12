require File.dirname(__FILE__) + '/../spec_helper'

describe ResultsController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should update comment record" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.results.first.id.to_s,
      :result => { :comment_attributes => { :text => 'roberts' } }
    @patient.results.first.comment.text.should == 'roberts'
  end

  it "should assign @result on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:result].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.results.first.id.to_s
    response.should render_template('results/edit')
  end

  it "should assign @result on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.results.first.id.to_s
    assigns[:result].should == @patient.results.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('results/create')
  end

  it "should assign @result on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:result].should_not be_new_record
  end

  it "should add an result on post create" do
    old_result_count = @patient.results.count
    post :create, :patient_id => @patient.id.to_s
    @patient.results(true).count.should == old_result_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.results.first.id.to_s
    response.should render_template('results/_show')
  end

  it "should update result on put update" do
    existing_result = @patient.results.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_result.id.to_s,
      :result => { :result_code_display_name => 'foobar' }
    existing_result.reload
    existing_result.result_code_display_name.should == 'foobar'
  end

  it "should remove from @patient.results on delete destroy" do
    existing_result = @patient.results.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_result.id.to_s
    @patient.results(true).should_not include(existing_result)
  end

end

