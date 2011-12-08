require 'test_helper'

class MeasuresHelperTest < ActionView::TestCase
  
  test "should be able to iterate through a list of sub ids" do
    subs = ['a']
    subs_iterator(subs) do |sub_id|
      assert_equal 'a', sub_id
    end
  end
  
  test "should iterate once when there are no sub ids" do
    subs = [nil]
    subs_iterator(subs) do |sub_id|
      assert sub_id.nil?
    end
  end
  
  test "should be able to find a value in the results" do
    results = {:bar => 'foo'}
    answer = value_or_default(results, :bar, 0)
    assert_equal 'foo', answer
  end
  
  test "should return the default when it can't find the result" do
    results = {}
    answer = value_or_default(results, :bar, 0)
    assert_equal 0, answer
  end
  
  test "should be able to calculate the percentage for a measure" do
    results = {'numerator' => 2, 'denominator' => 3}
    answer = percentage(results)
    assert_equal 66, answer
  end
end