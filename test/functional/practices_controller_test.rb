require 'test_helper'
include Devise::TestHelpers
class PracticesControllerTest < ActionController::TestCase
  setup do
    dump_database
    collection_fixtures 'users', 'practices', 'providers'
    
    @user = User.where({email: 'admin@test.com'}).first    
    @non_user = User.where({email: 'noadmin@test.com'}).first    
    @practice = Practice.all.first
    @provider = Provider.first
    @provider.id = @provider._id
    Practice.all.each do |prac|
      prac.provider = @provider
      prac.save!
    end
    @provider.save!
  end

  test "should get index" do
    sign_in @user
    get :index
    assert_response :success
  end

  test 'should not get index for non admin' do
    sign_in @non_user
    get :index
    assert_response 403
  end

  test "should show a practice" do
    sign_in @user
    get :show, :id => @practice._id
    assert_response :success
  end

  test "should raise error when viewing an unknown practice" do
    sign_in @user
    assert_raise(Mongoid::Errors::DocumentNotFound) { get :show, :id => 'invalidid' }   # Expect this with default Mongo configuration
    #assert_redirected_to :action => :index  # Would expect this if you disable Mongo raies_not_found_error
  end

  test "should not show a practice for non admin" do
    sign_in @non_user
    get :show, :id => @practice._id
    assert_response 403
  end

  test "should create practice" do
    sign_in @user
    
    assert_difference('Practice.count') do
      post :create, practice: {:name => 'Test Organization', :organization => 'Org 2'}, user: @user.id
    end
    new_org = Practice.where(:name => 'Test Organization').first
    assert new_org 
    assert_redirected_to :action => :index
  end
  
  test "should not create practice for non admin" do
    sign_in @non_user
    
    assert_no_difference('Practice.count') do
      post :create, practice: {:name => 'Test Org 2'}
    end
    assert_response 403
  end

  test "should edit practice" do
    sign_in @user
    
    assert_no_difference('Practice.count') do
      put :update, id: @practice.id, practice: {:name => 'Updated Organization' }, user: @non_user.id
    end

    updated_practice = Practice.find(@practice)
    assert_equal 'Updated Organization', updated_practice.name
    assert_redirected_to :action => :index
  end

  test "should not edit practice for non admin" do
    sign_in @non_user
    
    assert_no_difference('Practice.count') do
      put :update, id: @practice.id, practice: {:name => 'Updated Organization' }, user: @user.id
    end
    assert_response 403
  end

  test 'should delete practice' do
    sign_in @user
    
    assert_difference('Practice.count', -1) do
      post :destroy, :id => @practice.id
    end
    assert_redirected_to :action => :index
  end

  test 'should not delete practice for non admin' do
    sign_in @non_user
    
    assert_no_difference('Practice.count') do
      post :destroy, :id => @practice.id
    end
    assert_response 403
  end


end

