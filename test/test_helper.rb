require 'cover_me'
# at_exit do
#   CoverMe.complete!
# end
ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'factory_girl'

FactoryGirl.find_definitions

class ActiveSupport::TestCase


  def dump_database
    User.all.each {|x| x.destroy}
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
  
end

