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

