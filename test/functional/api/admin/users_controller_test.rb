require 'test_helper'
include Devise::TestHelpers
module Api
  module Admin
    class UsersControllerTest < ActionController::TestCase

      setup  do

        dump_database

        collection_fixtures 'users'

        @admin = User.where({email: 'admin@test.com'}).first
        @user = User.where({email: 'noadmin@test.com'}).first
        @unapproved_user = User.where({email: 'unapproved@test.com'}).first
        @no_staff_user = User.where({email: 'unapproved@test.com'}).first
        @admin2 = User.where({email: 'admin2@test.com'}).first
        
      end

      test "admin users index should return users in database" do
        sign_in @admin
        get :index
        assert_response :success
        json = JSON.parse(response.body)
        assert_equal 11, json.count
      end

      test "promote user to admin" do
        sign_in @admin
        post :promote, id: @user.id, role: 'admin'
        assert_response :success
        @user.reload
        assert_equal @user.admin, true
      end

      test "demote user from admin" do
        sign_in @admin
        post :demote, id: @admin2.id, role: 'admin'
        assert_response :success
        @admin2.reload
        assert_equal @admin2.admin, false
      end

      test "promote user to staff role" do
        sign_in @admin
        post :promote, id: @no_staff_user.id, role: 'staff_role'
        assert_response :success
        @no_staff_user.reload
        assert_equal @no_staff_user.staff_role, true
      end

      test "demote user from staff role" do
        sign_in @admin
        post :demote, id: @admin2.id, role: 'staff_role'
        assert_response :success
        @admin2.reload
        assert_equal @admin2.staff_role, false
      end

      test "enable user account" do
        sign_in @admin
        get :enable, id: @unapproved_user.id
        assert_response :success
        @unapproved_user.reload
        assert_equal @unapproved_user.disabled, false
      end

      test "disable user account" do
        sign_in @admin
        get :disable, id: @unapproved_user.id
        assert_response :success
        @unapproved_user.reload
        assert_equal @unapproved_user.disabled, true
      end

      test "approve user account" do
        sign_in @admin
        get :approve, id: @unapproved_user.id
        assert_response :success
        @unapproved_user.reload
        assert_equal @unapproved_user.approved, true
      end

      test "update user npi" do
        sign_in @admin
        get :update_npi, id: @user.id, npi: "NewNPI"
        assert_response :success
        @user.reload
        assert_equal @user.npi, "NewNPI"
      end

    end
  end
end
