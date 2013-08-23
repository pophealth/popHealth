require 'test_helper'

class PatientsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
    
  setup do
    dump_database
    @record = Factory(:record)
    @user = Factory(:user_w_selected_measures)
    sign_in @user
  end
  
  test "view patient" do
    get :show, id: @record.id
  end
  
end