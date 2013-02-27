# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
PopHealth::Application.initialize!

Provider.send(:include, Kaminari::MongoidExtension::Document)
Record.send(:include, Kaminari::MongoidExtension::Document)

require_relative '../lib/oid_helper'
require_relative '../lib/hds/record.rb'
require_relative '../lib/hds/provider.rb'
require_relative '../lib/hds/provider_performance.rb'
require_relative '../lib/qme/quality_report.rb'