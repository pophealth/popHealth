require 'test_helper'

  module Api
  class PatientsControllerTest < ActionController::TestCase
    include Devise::TestHelpers
      
    setup do
      dump_database
      @record = Factory(:record)
      @user = Factory(:user)
      sign_in @user
    end
    
    test "view patient" do
      get :show, id: @record.id
    end
    
  end
end