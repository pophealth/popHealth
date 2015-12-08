require 'test_helper'
class PatientsHelperTest < ActionView::TestCase

	setup do
		load_code_sets
		collection_fixtures('records', "_id")

		@patient = Record.find('4f5bb2ef1d41c841b3000502')

	end

	test "race" do
		assert_equal "American Indian Or Alaska Native", race(@patient)
	end

	test "ethinictity" do
		assert_equal "Not Hispanic or Latino", ethnicity(@patient)
	end

end