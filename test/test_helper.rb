require 'cover_me'
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'factory_girl'
require 'mocha/setup'

FactoryGirl.find_definitions

class ActiveSupport::TestCase


  def dump_database
    User.delete_all
    Provider.delete_all
    Record.delete_all
    Team.delete_all
    db = Mongoid.default_session
    db['measures'].drop()
    db['selected_measures'].drop()
    db['records'].drop
    db['patient_cache'].drop
    db['query_cache'].drop
  end

  def raw_post(action, body, parameters = nil, session = nil, flash = nil)
    @request.env['RAW_POST_DATA'] = body
    post(action, parameters, session, flash)
  end
  
  def basic_signin(user)
     @request.env['HTTP_AUTHORIZATION'] = "Basic #{ActiveSupport::Base64.encode64("#{user.username}:#{user.password}")}"
  end

  def collection_fixtures(*collection_names)
    collection_names.each do |collection|
      MONGO_DB[collection].drop
      Dir.glob(File.join(Rails.root, 'test', 'fixtures', collection, '*.json')).each do |json_fixture_file|
        fixture_json = JSON.parse(File.read(json_fixture_file))
          MONGO_DB[collection].insert(fixture_json)
      end
    end
  end
  
  def hash_includes?(expected, actual)
    if (actual.is_a? Hash)
      (expected.keys & actual.keys).all? {|k| expected[k] == actual[k]}
    elsif (actual.is_a? Array )
      actual.any? {|value| hash_includes? expected, value}
    else 
      false
    end
  end
  
  def assert_false(value) 
    assert !value
  end
  
  def assert_query_results_equal(factory_result, result)
    
    factory_result.each do |key, value|
      assert_equal value, result[key] unless key == '_id'
    end
    
  end
  
  
end

