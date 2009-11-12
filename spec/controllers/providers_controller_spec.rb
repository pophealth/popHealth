require File.dirname(__FILE__) + '/../spec_helper'

describe ProvidersController do
  before do
    @patient = Patient.factory.create
    controller.stub!(:current_user).and_return(@patient.user)
  end

  it "should update comment record" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.providers.first.id.to_s,
      :provider => { :comment_attributes => { :text => 'roberts' } }
    @patient.providers.first.comment.text.should == 'roberts'
  end

  it "should assign @provider on get new" do
    get :new, :patient_id => @patient.id.to_s
    assigns[:provider].should be_new_record
  end

  it "should render edit template on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.providers.first.id.to_s
    response.should render_template('providers/edit')
  end

  it "should assign @provider on get edit" do
    get :edit, :patient_id => @patient.id.to_s, :id => @patient.providers.first.id.to_s
    assigns[:provider].should == @patient.providers.first
  end

  it "should render create template on post create" do
    post :create, :patient_id => @patient.id.to_s
    response.should render_template('providers/create')
  end

  it "should add an provider on post create" do
    old_provider_count = @patient.providers.count
    post :create, :patient_id => @patient.id.to_s
    @patient.providers(true).count.should == old_provider_count + 1
  end

  it "should render show partial on put update" do
    put :update, :patient_id => @patient.id.to_s, :id => @patient.providers.first.id.to_s
    response.should render_template('providers/_show')
  end

  it "should update provider on put update" do
    existing_provider = @patient.providers.first
    put :update, :patient_id => @patient.id.to_s, :id => existing_provider.id.to_s,
      :provider => { :provider_role_free_text => 'foobar' }
    existing_provider.reload
    existing_provider.provider_role_free_text.should == 'foobar'
  end

  it "should remove from @patient.providers on delete destroy" do
    existing_provider = @patient.providers.first
    delete :destroy, :patient_id => @patient.id.to_s, :id => existing_provider.id.to_s
    @patient.providers(true).should_not include(existing_provider)
  end

end

