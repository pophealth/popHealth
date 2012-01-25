# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
PopHealth::Application.initialize!

Record.send(:include, Kaminari::MongoidExtension::Document)
require_relative '../lib/hds/record.rb'