source 'http://rubygems.org'

gem 'rails', '3.2.14'

# added:
gem 'rack', '1.4.5'

#gem 'quality-measure-engine', '~> 2.3.0'
#gem "health-data-standards", '~> 3.0.2'
#gem 'quality-measure-engine', '2.1.0', :git => 'https://github.com/pophealth/quality-measure-engine.git', :branch => 'develop'
#gem "health-data-standards", '3.2.7', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'develop'

gem 'quality-measure-engine', :path => "../quality-measure-engine"
gem "health-data-standards", :path => "../health-data-standards"


gem 'nokogiri', '1.6.0'#'~>1.5.5' #'1.5.10'
gem 'rubyzip', '0.9.9'

gem "will_paginate", '3.0.4'# we need to get rid of this, very inefficient with large data sets and mongoid
gem "kaminari", '0.14.1'

gem 'json', '1.8.0', :platforms => :jruby
# these are all tied to 1.3.1 because bson 1.4.1 was yanked.  To get bundler to be happy we need to force 1.3.1 to cause the downgrade

# added from bstrezze
gem 'bson', '1.9.2'
gem 'bson_ext', '1.9.2', :platforms => :mri

gem "mongoid", '3.1.4'

gem 'devise', '3.0.2'

gem 'foreman', '0.63.0'
gem "thin", '1.5.1'
gem 'formtastic', '2.2.1'
gem 'cancan', '1.6.10'
gem 'factory_girl', "2.6.3"
gem "rails-backbone", '0.9.10'
# Windows doesn't have syslog, so need a gem to log to EventLog instead
gem 'win32-eventlog', :platforms => [:mswin, :mingw]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.6'
  gem 'coffee-rails', '3.2.2'
  gem 'uglifier', '2.1.2'
  gem "bootstrap-sass", '2.3.2.1'
  gem 'jquery-datatables-rails', :path => '../jquery-datatables-rails'
  gem 'jquery-ui-rails', '4.0.4'
 # gem 'jquery-modal-rails', '0.0.3' #added by ssiddiqui
end

group :test, :develop do
  gem 'pry', '0.9.12.2'
  gem "unicorn", '4.6.3', :platforms => [:ruby, :jruby]
  gem 'turn', '0.9.6', :require => false
  gem 'cover_me', '1.2.0'
  gem 'minitest', '5.0.6'
  gem 'mocha', '0.14.0', :require => false
end

group :production do
  gem 'libv8', '3.11.8.17'
  gem 'therubyracer', '0.11.4', :platforms => [:ruby, :jruby] # 10.8 mountain lion compatibility
end

gem 'jquery-rails', '2.1.4'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

