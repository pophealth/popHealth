require 'test_helper'

class ProviderTest < ActiveSupport::TestCase

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
