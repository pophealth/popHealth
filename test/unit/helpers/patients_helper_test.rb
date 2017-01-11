require 'test_helper'
class PatientsHelperTest < ActionView::TestCase

	setup do
		load_code_sets
		collection_fixtures('records', "_id")

		@patient = Record.find('523c57e1b59a907ea9000064')

	end

	test "race" do
		assert_equal "American Indian Or Alaska Native", race(@patient)
	end

	test "ethinictity" do
		assert_equal "Not Hispanic or Latino", ethnicity(@patient)
	end

end