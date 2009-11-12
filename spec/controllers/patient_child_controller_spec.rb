require File.dirname(__FILE__) + '/../spec_helper'

class TestPatientChildrenController < PatientChildrenController
  def hiworld
    render :text => 'hiworld'
  end
end

def test_patient_child_routes
  with_routing do |map|
    map.draw {|test| test.connect "/patient_child/hi", :controller => 'test_patient_children', :action => 'hiworld' }
    yield
  end
end

describe TestPatientChildrenController do
  describe "as a subclass of PatientChildrenController" do
    before(:each) do
      controller.stub!(:current_user).and_return(mock_model(User))
    end

    it "should redirect when there is no patient_id parameter" do
      test_patient_child_routes do
        get :hiworld
        response.should redirect_to('/patients')
      end
    end

    it "should not redirect when there is a patient_id parameter" do
      test_patient_child_routes do
        Patient.stub!(:find).and_return(mock_model(Patient, :editable_by? => true))
        get :hiworld, :patient_id => 1
        response.should be_success
      end
    end

    it "should determine the association based on controller name" do
      controller.send(:association_name).should == 'test_patient_children'
    end

    it "should determine the param key based on controller name" do
      controller.send(:param_key).should == :test_patient_child
    end

    it "should determine the instance var based on controller name" do
      controller.send(:instance_var_name).should == '@test_patient_child'
    end

  end
end
