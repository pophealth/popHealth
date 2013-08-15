require 'test_helper'


class RecordsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    dump_database
    @user = Factory(:admin)
    @body = File.new("test/fixtures/patient_provider_fragment.xml").read
    @body2 = File.new("test/fixtures/patient_sample.xml").read
    @ccr_body = File.new("test/fixtures/sample_ccr.xml").read
    @cat1_body = File.new("test/fixtures/sample_cat1.xml").read
    sign_in @user
  end
  
  test "send junk xml" do
    raw_post(:create, "<root>i am random xml that should not work</root>")
    assert_response(400)
  end
  
  test "unauthenticated create" do
    sign_out @user
    
    assert_throws(:warden) do
      raw_post(:create, @body)
    end
  
  end
  
  # CCR support temporarily removed until HDS is updated
  # test "create record ccr with providers" do
  #   raw_post(:create, @ccr_body)
  #   assert_response(201)
  #   # assert_not_nil assigns(:record)
    
  #   created_record = Record.where().first
    
  #   assert_not_nil created_record
  #   assert_equal 1, created_record.providers.count
  # end
  
  test "create without admin privileges" do
    sign_out @user
    sign_in Factory(:user)
    raw_post(:create, @body)
    assert_response 403
  end
  
  test "create record c32 with providers" do
    raw_post(:create, @body)
    assert_response(201)
    # assert_not_nil assigns(:record)
    
    created_record = Record.first
    
    # test creation
    assert_not_nil created_record
    # binding.pry
    assert_equal 2, Record.first.providers.count
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

  test "create record with QRDA Cat 1" do
    raw_post(:create, @cat1_body)
    assert_response(201)
    
    created_record = Record.first
    assert_equal 7, created_record.encounters.count
  end
  
  test "replace existing record" do
    # create one record
    raw_post(:create, @body)
    assert_response(201)
    # assert_not_nil assigns(:record)
    created_records = Record.all().to_a
    assert_equal 1, created_records.size
    assert_equal 'PatientID', created_records[0].medical_record_number
    assert_equal 'FirstName', created_records[0].first

    # re-upload another record with the same medical_record_number and make sure it overwrites the existing one
    raw_post(:create, @body2)
    assert_response(201)
    # assert_not_nil assigns(:record)
    created_records = Record.all().to_a
    assert_equal 1, created_records.size
    assert_equal 'PatientID', created_records[0].medical_record_number
    assert_equal 'Fred', created_records[0].first
  end
  
end