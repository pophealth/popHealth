source 'http://rubygems.org'

gem 'rails', '3.1.0'
# locked to 1.3.3 to resolve annoying warning 'already initialized constant WFKV_'
gem 'rack' , '1.3.3'

gem 'quality-measure-engine', '1.1.3'
# gem 'quality-measure-engine', :git => 'http://github.com/pophealth/quality-measure-engine.git', :branch => 'master'
gem 'health-data-standards', '0.8.1'
# gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'master'

gem 'nokogiri'
gem 'rubyzip'

gem "will_paginate" # we need to get rid of this, very inefficient with large data sets and mongoid
gem "kaminari"

gem 'json', :platforms => :jruby
# these are all tied to 1.3.1 because bson 1.4.1 was yanked.  To get bundler to be happy we need to force 1.3.1 to cause the downgrade
gem "mongo", "1.3.1"
gem "bson", "1.3.1"
gem 'bson_ext',"1.3.1",  :platforms => :mri
gem "mongoid"
gem 'devise', "~> 2.0.0"
gem 'foreman'
gem 'pry'
gem 'formtastic'
gem 'cancan'
gem 'factory_girl'

# Windows doesn't have syslog, so need a gem to log to EventLog instead
gem 'win32-eventlog', :platforms => [:mswin, :mingw]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
end

group :test, :develop do
  # gem "rspec-rails"
  # Pretty printed test output
  gem "unicorn", :platforms => [:ruby, :jruby]
  gem 'turn', :require => false
  gem 'cover_me'
  gem 'minitest'
  gem 'mocha', :require => false
end

group :production do
  # Is there an easy way to say "all platforms except :mswin, :mingw" without
  # explicitly listing all other platforms?
  gem 'therubyracer', :platforms => [:ruby, :jruby]
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

