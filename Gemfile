source 'http://rubygems.org'

gem 'rails', '3.2.14'

gem 'quality-measure-engine', '2.5.1'

gem "health-data-standards", '3.2.8'
gem 'nokogiri'
gem 'rubyzip'

gem "will_paginate" # we need to get rid of this, very inefficient with large data sets and mongoid
gem "kaminari"

gem 'json', :platforms => :jruby
# these are all tied to 1.3.1 because bson 1.4.1 was yanked.  To get bundler to be happy we need to force 1.3.1 to cause the downgrade

gem "mongoid"

gem 'devise'

gem 'foreman'
gem "thin"
gem 'formtastic'
gem 'cancan'
gem 'factory_girl', "2.6.3"
gem "rails-backbone"
# Windows doesn't have syslog, so need a gem to log to EventLog instead
gem 'win32-eventlog', :platforms => [:mswin, :mingw]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem "bootstrap-sass"
end

group :test, :develop do
  gem 'pry'
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

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

