source 'http://rubygems.org'

gem 'rails', '~> 4.0.4'
gem 'quality-measure-engine', :path => '../quality-measure-engine'

gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git'
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

gem 'protected_attributes', '~> 1.0.5'

gem 'foreman'
gem "thin"
gem 'formtastic'
gem 'cancan'
gem 'factory_girl', "2.6.3"
gem 'apipie-rails'

gem 'sprockets', '~> 2.12.0'

# Gems used for assets
gem 'less-rails'
gem 'sass-rails'
gem 'coffee-rails'
gem 'uglifier'
gem "bootstrap-sass"

group :test, :develop, :ci do
  gem 'pry'
  gem 'jasmine', '2.0.1'
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
