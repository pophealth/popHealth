require File.dirname(__FILE__) + '/../spec_helper'

describe ConditionsController do
  it "should respond to an autocomplete request" do
    controller.stub!(:current_user).and_return(stub(:user))
    get :auto_complete_for_snowmed_problem_name, :snowmed_problem => { :name => 'x' }
    response.should be_success
  end

  describe "with a patient" do
    before do
      @patient = Patient.factory.create
      controller.stub!(:current_user).and_return(@patient.user)
    end

    it "should update comment record" do
      put :update, :patient_id => @patient.id.to_s, :id => @patient.conditions.first.id.to_s,
        :condition => { :comment_attributes => { :text => 'roberts' } }
      @patient.conditions.first.comment.text.should == 'roberts'
    end

    it "should assign @condition on get new" do
      get :new, :patient_id => @patient.id.to_s
      assigns[:condition].should be_new_record
    end

    it "should render edit template on get edit" do
      get :edit, :patient_id => @patient.id.to_s, :id => @patient.conditions.first.id.to_s
      response.should render_template('conditions/edit')
    end

    it "should assign @condition on get edit" do
      get :edit, :patient_id => @patient.id.to_s, :id => @patient.conditions.first.id.to_s
      assigns[:condition].should == @patient.conditions.first
    end

    it "should render create template on post create" do
      post :create, :patient_id => @patient.id.to_s
      response.should render_template('conditions/create')
    end

    it "should assign @condition on post create" do
      post :create, :patient_id => @patient.id.to_s
      assigns[:condition].should_not be_new_record
    end

    it "should add an condition on post create" do
      old_condition_count = @patient.conditions.count
      post :create, :patient_id => @patient.id.to_s
      @patient.conditions(true).count.should == old_condition_count + 1
    end

    it "should render show partial on put update" do
      put :update, :patient_id => @patient.id.to_s, :id => @patient.conditions.first.id.to_s
      response.should render_template('conditions/_show')
    end

    it "should update condition on put update" do
      existing_condition = @patient.conditions.first
      put :update, :patient_id => @patient.id.to_s, :id => existing_condition.id.to_s, :condition => { :free_text_name => 'foobar'}
      existing_condition.reload
      existing_condition.free_text_name.should == 'foobar'
    end

    it "should remove from @patient.conditions on delete destroy" do
      existing_condition = @patient.conditions.first
      delete :destroy, :patient_id => @patient.id.to_s, :id => existing_condition.id.to_s
      @patient.conditions(true).should_not include(existing_condition)
    end
  end

end

