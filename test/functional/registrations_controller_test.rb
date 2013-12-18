require 'test_helper'
include Devise::TestHelpers

class RegistrationsControllerTest < ActionController::TestCase

  setup do
    dump_database
    @user = Factory(:user)
  end

  test "a signed in user can update their account information via HTML" do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    # passwords will be blank
    put :update, user: { current_password: '', password: '', password_confirmation: '', company: 'The MITRE Corp' }
    assert_response :redirect
    assert_equal 'The MITRE Corp', assigns[:user].company
  end

  test "a signed in user can update their account information via JSON" do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    put :update, user: { company: 'The MITRE Corp' }, format: :json
    assert_response :success
    assert_equal 'The MITRE Corp', assigns[:user].company
  end

  test "a signed in user must supply their current password if they attempt to update their password via HTML" do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    put :update, user: {password: 'something new', password_confirmation: 'something new'}
    assert_response :success
    assert_equal ["Current password can't be blank"], assigns[:user].errors.full_messages

    put :update, user: {current_password: 'password', password: 'something new', password_confirmation: 'something new'}
    assert_response :redirect
  end

  test "a signed in user must supply their current password if they attempt to update their password via JSON" do
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in @user
    put :update, user: {password: 'something new', password_confirmation: 'something new'}, format: :json
    assert_response :not_acceptable

    put :update, user: {current_password: 'password', password: 'something new', password_confirmation: 'something new'}, format: :json
    assert_response :success
  end
end
