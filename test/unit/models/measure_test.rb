require 'test_helper'

class MeasureTest < ActiveSupport::TestCase
  setup do
    dump_database
    collection_fixtures 'measures', 'selected_measures'
  end

  # All these tests have been deprecated
  # test 'should group measures by category' do
  #   measures = Measure.all_by_category
  #   core = measures.find {|category| category['category'] == 'Core'}
  #   assert_not_nil core
  #   assert hash_includes? ({'name' => 'Hypertension: Blood Pressure Measurement', 'id' => '0013'}), core['measures']
  #   assert hash_includes? ({'name' => 'Adult Weight Screening and Follow-Up', 'id' => '0421'}), core['measures']
  #   assert_false hash_includes? ({'name' => 'Cervical Cancer Screening', 'id' => '0032'}), core['measures']
  # end

  # test 'should group measures' do
  #   measures = Measure.all_by_measure
  #   aws = measures.find {|measure| measure['id'] == '0421'}
  #   assert_equal 'Adult Weight Screening and Follow-Up', aws['name']
  #   assert_equal 2, aws['subs'].length

  #   ccs = measures.find {|measure| measure['id'] == '0032'}
  #   assert ccs['subs'].empty?
  # end

  # test 'should find non core measures' do
  #   measures = Measure.non_core_measures
  #   assert_equal 1, measures.length

  #   assert measures.map {|c| c['category']}.include?("Women's Health")
  #   assert_false measures.map {|c| c['category']}.include?('Core')
  #   ccs = measures.find {|category| category['category'] == "Women's Health"}['measures'].first
  #   assert_equal 'Cervical Cancer Screening', ccs['name']
  # end

  # test 'should find core measures' do
  #   measures = Measure.core_measures
  #   assert_equal 2, measures.length

  #   aws = measures.find {|measure| measure['id'] == '0421'}
  #   assert_equal 'Adult Weight Screening and Follow-Up', aws['name']
  # end

  # test "should add a measure to the selected measures if it isn't there" do
  #   measure = Measure.add_measure('andy','0421')
  #   assert_equal 'Adult Weight Screening and Follow-Up', measure['name']
  #   assert_equal 2, MONGO_DB['selected_measures'].count
  # end

  # test "shouldn't add a measure if it is already there" do
  #   assert Measure.add_measure('andy', '0032').nil?
  # end

  # test "should be able to remove a measure" do
  #   Measure.remove_measure('andy', '0032')
  #   assert_equal 0, MONGO_DB['selected_measures'].count
  # end
end