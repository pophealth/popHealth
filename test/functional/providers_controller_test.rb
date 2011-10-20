require 'test_helper'

class ProvidersControllerTest < ActionController::TestCase
  
  setup do
    @user = Factory(:user)
    basic_signin(@user)
  end
  
  test "index" do
    get :index
  end

end
