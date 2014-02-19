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

  test "should import providers from OPML properly" do
    provider_tree = ProviderTreeImporter.new(File.new('test/fixtures/providers.opml'))
    provider_tree.load_providers(provider_tree.sub_providers)
    leaf = Provider.where(:given_name => "Newington VANURS").first
    first_parent = Provider.where(:_id => leaf.parent_id).first
    root = Provider.where(:_id => first_parent.parent_id).first
    assert_equal leaf.npi, "6279AA"
    assert_equal first_parent.npi, "627"
    assert_equal root.npi, "1"
  end
end