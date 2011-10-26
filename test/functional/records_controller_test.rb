require 'test_helper'
include Devise::TestHelpers

class RecordsControllerTest < ActionController::TestCase
  
  setup do
    dump_database
    @user = Factory(:user)
    basic_signin(@user)
    @body = File.new("test/fixtures/patient_provider_fragment.xml").read
  end
  
  test "send junk xml" do
    raw_post(:create, "<root>i am random xml that should not work</root>")
    assert_response(400)
  end
  
  test "create record with providers" do
    raw_post(:create, @body)
    assert_response(201)
    assert_not_nil assigns(:record)
    
    created_record = Record.find(:first)
    
    # test creation
    assert_not_nil created_record
    assert_equal 2, Provider.count
    assert_equal 2, Record.with_provider.map {|record| record.provider_performances.count}.sum
    
    # test relationship
    Record.with_provider.map do |record|
      record.provider_performances.each do |pp|
        assert_not_nil pp.record
        assert_not_nil pp.provider
      end
    end
    assert_equal 2, created_record.provider_performances.size
  end
  
end