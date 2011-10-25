source 'http://rubygems.org'

gem 'rails', '3.1.0'
# locked to 1.3.3 to resolve annoying warning 'already initialized constant WFKV_'
gem 'rack' , '1.3.3'

gem 'quality-measure-engine', :git => 'https://github.com/pophealth/quality-measure-engine.git', :branch => 'develop'
gem 'nokogiri'
gem 'rubyzip'

gem "will_paginate"
gem 'json', :platforms => :jruby
gem 'bson_ext', :platforms => :mri
gem "mongoid"
gem 'devise'
gem 'foreman'
gem 'pry'
gem 'formtastic'
gem 'cancan'

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
  gem "rspec-rails"
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'cover_me'
  gem 'factory_girl'
  gem 'minitest'
  gem 'mocha'
end

gem 'jquery-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

