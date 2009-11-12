require File.dirname(__FILE__) + '/../test_helper'

class ElementsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:elements)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_element
    assert_difference('Element.count') do
      post :create, :element => { }
    end

    assert_redirected_to element_path(assigns(:element))
  end

  def test_should_show_element
    get :show, :id => elements(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => elements(:one).id
    assert_response :success
  end

  def test_should_update_element
    put :update, :id => elements(:one).id, :element => { }
    assert_redirected_to element_path(assigns(:element))
  end

  def test_should_destroy_element
    assert_difference('Element.count', -1) do
      delete :destroy, :id => elements(:one).id
    end

    assert_redirected_to elements_path
  end
end
