require File.dirname(__FILE__) + '/../spec_helper'

describe AllergiesController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should update comment record" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.allergies.first.id.to_s,
      :allergy => { :comment_attributes => { :text => 'roberts' } }
    @patient.allergies.first.comment.text.should == 'roberts'
  end

  it "should not update patient allergy flag on get new" do
    @patient.update_attributes!(:no_known_allergies => true)
    get :new, :patient_id => @patient.id.to_s
    @patient.reload
    @patient.no_known_allergies.should == true
  end

  it "should update patient allergy flag on post create" do
    @patient.update_attributes!(:no_known_allergies => true)
    post :create, :patient_id => @patient.id.to_s
    @patient.reload
    @patient.no_known_allergies.should == false
  end

  it "should assign @allergy on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:allergy].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.allergies.first.id.to_s
    response.should render_template('allergies/edit')
  end

  it "should assign @allergy on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.allergies.first.id.to_s
    assigns[:allergy].should == @patient.allergies.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('allergies/create')
  end

  it "should assign @allergy on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:allergy].should_not be_new_record
  end

  it "should add an allergy on post create" do
    old_allergy_count = @patient.allergies.count
    post :create, :patient_id => @patient.id.to_s
    @patient.allergies(true).count.should == old_allergy_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.allergies.first.id.to_s
    response.should render_template('allergies/_show')
  end

  it "should update allergy on put update" do
    existing_allergy = @patient.allergies.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_allergy.id.to_s,
      :allergy => { :free_text_product => 'foobar' }
    existing_allergy.reload
    existing_allergy.free_text_product.should == 'foobar'
  end

  it "should render no_known_allergies_link partial on delete destroy" do
    delete :destroy, :patient_id => @patient.id.to_s, :id => @patient.allergies.first.id.to_s
    response.should render_template('allergies/_no_known_allergies_link')
  end

  it "should remove from @patient.allergies on delete destroy" do
    existing_allergy = @patient.allergies.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_allergy.id.to_s
    @patient.allergies(true).should_not include(existing_allergy)
  end

end

