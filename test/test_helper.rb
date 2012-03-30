require 'rubygems'
require 'spork'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

Spork.prefork do
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.
  require 'cover_me'
  ENV["RAILS_ENV"] = "test"
  require File.expand_path('../../config/environment', __FILE__)
  require 'rails/test_help'

  require 'factory_girl'
  require 'mocha'
  
  FactoryGirl.find_definitions

  class ActiveSupport::TestCase

    def dump_database
      User.delete_all
      Provider.delete_all
      Record.delete_all
      Team.delete_all
      db = Mongoid::Config.master
      db['measures'].remove({})
      db['selected_measures'].remove({})
      db['records'].remove({})
      db['patient_cache'].remove({})
      db['query_cache'].remove({})
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
            MONGO_DB[collection].save(fixture_json)
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
end

Spork.each_run do
  # This code will be run each time you run your specs.
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.






