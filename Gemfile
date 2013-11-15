source 'http://rubygems.org'

gem 'rails', '3.2.14'
#gem 'quality-measure-engine', :path=>"../quality-measure-engine"
gem 'quality-measure-engine', :git=> "https://github.com/pophealth/quality-measure-engine.git", :branch=> "mongoid_refactor"

gem "health-data-standards", '3.2.8'
gem 'nokogiri'
gem 'rubyzip'

gem "will_paginate" # we need to get rid of this, very inefficient with large data sets and mongoid
gem "kaminari"

gem "active_model_serializers"

gem 'json', :platforms => :jruby
# these are all tied to 1.3.1 because bson 1.4.1 was yanked.  To get bundler to be happy we need to force 1.3.1 to cause the downgrade

gem "mongoid"

gem 'highline'

gem 'devise'

gem 'git'

gem 'foreman'
gem "thin"
gem 'formtastic'
gem 'cancan'
gem 'factory_girl', "2.6.3"

# FIXME remove this when we don't need old versions of backbone/underscore anymore
gem "rails-backbone"

# Windows doesn't have syslog, so need a gem to log to EventLog instead
gem 'win32-eventlog', :platforms => [:mswin, :mingw]


# backport fixes from future versions of Sprockets into a Rails 3-compatible gem
gem 'sprockets', '2.2.2.backport1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'less-rails'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem "bootstrap-sass"
end

group :test, :develop do
  gem 'pry'
  gem 'pry-debugger'
  gem 'jasmine'
  gem "unicorn", :platforms => [:ruby, :jruby]
  gem 'turn', :require => false
  gem 'simplecov', :require => false
  gem "minitest", "~> 4.0"
  gem 'mocha', :require => false
end

group :production do
  gem 'libv8', '~> 3.11.8.3'
  gem 'therubyracer', '~> 0.11.0beta5', :platforms => [:ruby, :jruby] # 10.8 mountain lion compatibility
end

gem 'handlebars_assets'
# FIXME remove this when we don't need old versions of jquery/backbone/underscore anymore
gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

