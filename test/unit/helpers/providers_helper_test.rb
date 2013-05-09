require 'test_helper'

class ProvidersHelperTest < ActionView::TestCase
  setup do
    dump_database
    @provider_without_name = FactoryGirl.create(:provider, :given_name => nil, :family_name => nil)
    @provider = Factory(:provider)
  end

  test "should format provider name" do
    formatted_name = formatted_provider_name(@provider)
    assert_equal "#{@provider.family_name.upcase}, #{@provider.given_name}", formatted_name
  end

  test "should return proxy formatted name for provider missing name" do
    formatted_name = formatted_provider_name(@provider_without_name)
    assert_equal "#{@provider_without_name.id}, Provider", formatted_name
  end

  test "should return blank formatted name for null provider" do
    formatted_name = formatted_provider_name(nil)
    assert_equal "", formatted_name
  end
end
