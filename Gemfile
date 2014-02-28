source 'http://rubygems.org'

gem 'rails', '3.2.14'
gem 'quality-measure-engine', '3.0.0.beta.2'

gem 'health-data-standards', '3.4.2'
gem 'nokogiri'
gem 'rubyzip'

# Should be removed in the future. This is only used for the
# admin log page. When the admin pages are switched to 
# client side pagination, this can go away.
gem 'will_paginate'

gem "active_model_serializers"

gem 'json', :platforms => :jruby

gem "mongoid"

gem 'highline'

gem 'devise'

gem 'git'

gem 'foreman'
gem "thin"
gem 'formtastic'
gem 'cancan'
gem 'factory_girl', "2.6.3"
gem 'apipie-rails'

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

group :test, :develop, :ci do
  gem 'pry'
  gem 'jasmine', '2.0.0'
  gem 'turn', :require => false
  gem 'simplecov', :require => false
  gem 'mocha', :require => false
  gem "unicorn", :platforms => [:ruby, :jruby]
  gem 'minitest', "~> 4.0"
end

group :test, :develop do
  gem 'pry-debugger'
end

group :production do
  gem 'libv8', '~> 3.16.14.3'
  gem 'therubyracer', '~> 0.12.0', :platforms => [:ruby, :jruby] # 10.8 mountain lion compatibility
end

gem 'handlebars_assets'
# FIXME remove this when we don't need old versions of jquery/backbone/underscore anymore
gem 'jquery-rails'
