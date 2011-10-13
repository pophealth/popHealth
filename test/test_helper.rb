ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'factory_girl'

FactoryGirl.find_definitions

class ActiveSupport::TestCase


  def dump_database
    User.all.each {|x| x.destroy}
end

  
end

