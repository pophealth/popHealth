# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec
end

module LoginHelper
  def mock_user
    @mock_user ||= mock_model('Users', :username => "andy", :effective_date => nil, :admin? => true)
  end
  
  def login
     request.env['warden'] = mock(Warden, :authenticate => mock_user,
                                          :authenticate! => mock_user,
                                          :user => mock_user)
  end
end


def collection_fixtures(*collection_names)
  collection_names.each do |collection|
    MONGO_DB[collection].drop
    Dir.glob(File.join(Rails.root, 'spec', 'fixtures', collection, '*.json')).each do |json_fixture_file|
      fixture_json = JSON.parse(File.read(json_fixture_file))
        MONGO_DB[collection].save(fixture_json)
    end
  end
end