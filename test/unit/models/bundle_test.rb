require 'test_helper'

class BundleTest < ActiveSupport::TestCase

  setup do
    dump_database
    collection_fixtures 'bundles'
  end

  test "should format license text if set" do
    bundle = Bundle.find_by(title: "No License")
    assert_nil bundle.license

    bundle = Bundle.find_by(title: "With License")
    assert_equal "Test license with \"text\" and \ndifferent newlines", bundle.license
  end
  
end
