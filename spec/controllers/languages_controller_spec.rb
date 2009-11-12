require File.dirname(__FILE__) + '/../spec_helper'

describe LanguagesController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should assign @language on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:language].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.languages.first.id.to_s
    response.should render_template('languages/edit')
  end

  it "should assign @language on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.languages.first.id.to_s
    assigns[:language].should == @patient.languages.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('languages/create')
  end

  it "should assign @language on post create" do
    post :create, :patient_id => @patient.id.to_s
    assigns[:language].should_not be_new_record
  end

  it "should add an language on post create" do
    old_language_count = @patient.languages.count
    post :create, :patient_id => @patient.id.to_s
    @patient.languages(true).count.should == old_language_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.languages.first.id.to_s
    response.should render_template('languages/_show')
  end

  it "should update language on put update" do
    existing_language = @patient.languages.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_language.id.to_s,
      :language => { :iso_language_id => '1234' }
    existing_language.reload
    existing_language.iso_language_id.should == 1234
  end

  it "should remove from @patient.languages on delete destroy" do
    existing_language = @patient.languages.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_language.id.to_s
    @patient.languages(true).should_not include(existing_language)
  end

end

