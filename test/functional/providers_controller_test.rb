require 'test_helper'
include Devise::TestHelpers

class ProvidersControllerTest < ActionController::TestCase
  
  setup do
    @user = Factory(:user)
    sign_in @user
  end
  
  test "index" do
    get :index
  end

end
