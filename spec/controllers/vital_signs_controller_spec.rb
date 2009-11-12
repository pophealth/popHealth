require File.dirname(__FILE__) + '/../spec_helper'

describe VitalSignsController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should update comment record" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.vital_signs.first.id.to_s,
      :vital_sign => { :comment_attributes => { :text => 'roberts' } }
    @patient.vital_signs.first.comment.text.should == 'roberts'
  end

  it "should assign @result on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:result].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.vital_signs.first.id.to_s
    response.should render_template('results/edit')
  end

  it "should assign @result on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.vital_signs.first.id.to_s
    assigns[:result].should == @patient.vital_signs.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('results/create')
  end

  it "should assign @result on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:result].should_not be_new_record
  end

  it "should add a vital_sign on post create" do
    old_vital_sign_count = @patient.vital_signs.count
    post :create, :patient_id => @patient.id.to_s
    @patient.vital_signs(true).count.should == old_vital_sign_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.vital_signs.first.id.to_s
    response.should render_template('results/_show')
  end

  it "should update vital_sign on put update" do
    existing_vital_sign = @patient.vital_signs.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_vital_sign.id.to_s,
      :vital_sign => { :result_code_display_name => 'foobar' }
    existing_vital_sign.reload
    existing_vital_sign.result_code_display_name.should == 'foobar'
  end

  it "should remove from @patient.vital_signs on delete destroy" do
    existing_vital_sign = @patient.vital_signs.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_vital_sign.id.to_s
    @patient.vital_signs(true).should_not include(existing_vital_sign)
  end

end

