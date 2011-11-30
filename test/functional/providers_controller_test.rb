require 'test_helper'
include Devise::TestHelpers

class ProvidersControllerTest < ActionController::TestCase

  setup do

    dump_database

    @user = Factory(:user)
    @provider = Factory(:provider)
    @other_provider = Factory(:provider)

    collection_fixtures 'measures'

    sign_in @user
  end


  test "get index" do
    get :index
    assert_not_nil assigns[:providers]
  end

  test "get show html" do
    get :show, id: @provider.id
    assert_not_nil assigns[:providers]
    assert_not_nil assigns[:provider]
    assert_template :show
    assert_response :success
  end

  test "get show js" do
    get :show, id: @provider.id, format: :js
    assert_not_nil assigns[:providers]
    assert_not_nil assigns[:provider]
    assert_template :show
    assert_response :success
  end

  test "edit provider" do
    get :edit, id: @provider.id
    assert_not_nil assigns[:providers]
    assert_response :success
    assert_template 'edit_profile'
  end

  test "update provider" do
    put :update, id: @provider.id, provider: @provider.attributes
    assert_response :success
    assert_template :show
  end

  test "get merge list" do
    get :merge_list, id: @provider.id
    assert_not_nil assigns[:providers]
    assert_response :success
    assert_template 'merge_form'
  end

  test "merge provider" do

    Provider.any_instance.expects(:merge_provider)
    Provider.any_instance.expects(:save!)

    assert_difference('Provider.count', -1) do
      put :merge, other_provider_id: @other_provider.id, id: @provider.id
    end

    assert (not Provider.exists? :conditions => {id: @other_provider.id})
    assert_redirected_to provider_url(@provider.id)
  end

end
