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
    first_parent = Provider.find(leaf.parent_id)
    root = Provider.find(first_parent.parent_id)
    assert_equal "6279AA", leaf.npi
    assert_equal "6279AA", leaf.cda_identifiers.where(root: 'Facility').first.extension
    assert_equal "627", first_parent.npi
    assert_equal "627", first_parent.cda_identifiers.where(root: 'Division').first.extension
    assert_equal "1", root.npi
    assert_equal "1", root.cda_identifiers.where(root: 'VISN').first.extension
  end
end