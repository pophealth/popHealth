require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  
  setup do
    dump_database
    @user1 = FactoryGirl.create(:provider,:given_name => "Bob")
  end
  
  test "should merge providers when npi blank" do
    user2 = FactoryGirl.create(:provider, :npi => nil, :given_name => "Alice")
    assert @user1.merge_provider(user2)
    assert_equal user2.specialty, @user1.specialty
    assert_not_equal @user1.given_name, user2.given_name
    # test records
  end
  
  test "should not merge providers when npi are different" do
    user2 = FactoryGirl.create(:provider)
    assert_false @user1.merge_provider(user2)
  end
  
end