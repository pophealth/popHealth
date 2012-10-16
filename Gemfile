source 'http://rubygems.org'

gem 'rails', '3.2.8' # was 3.1.0
# locked to 1.3.3 to resolve annoying warning 'already initialized constant WFKV_'
gem 'rack' , '1.4.1' # was 1.3.3

gem 'redis', '2.2.2'

# gem 'quality-measure-engine', '1.1.5'
# gem 'quality-measure-engine', :git => 'http://github.com/pophealth/quality-measure-engine.git', :branch => 'master'
gem 'quality-measure-engine', path: '../quality-measure-engine'
gem 'health-data-standards', '1.0.1'
# gem 'health-data-standards', :git => 'https://github.com/projectcypress/health-data-standards.git', :branch => 'master'
# gem 'health-data-standards', path: '../health-data-standards'

gem 'nokogiri', '1.5.5'
gem 'rubyzip', '0.9.9'

gem "will_paginate", '3.0.3' # we need to get rid of this, very inefficient with large data sets and mongoid
gem "kaminari", '0.13.0'

gem 'json', '1.4.6', :platforms => :jruby
# these are all tied to 1.3.1 because bson 1.4.1 was yanked.  To get bundler to be happy we need to force 1.3.1 to cause the downgrade
gem "mongo", "1.5.1"
gem "bson", "1.5.1"
gem 'bson_ext',"1.5.1",  :platforms => :mri
gem "mongoid", '2.4.10'
gem 'devise', "2.0.4"
gem 'foreman', '0.53.0'
gem 'pry', '0.9.10'
gem 'formtastic', '2.2.1'
gem 'cancan', '1.6.8'
gem 'factory_girl', "2.6.3"

# Windows doesn't have syslog, so need a gem to log to EventLog instead
gem 'win32-eventlog', :platforms => [:mswin, :mingw]

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '3.2.5' # was 3.1.6
  gem 'coffee-rails', '3.2.2' # was 3.1.1
  gem 'uglifier', '1.2.6'
end

group :test, :develop do
  # gem "rspec-rails"
  # Pretty printed test output
  gem "unicorn", '4.3.1', :platforms => [:ruby, :jruby]
  gem 'turn', '0.9.6', :require => false
  gem 'cover_me', '1.2.0'
  gem 'minitest', '3.3.0'
  gem 'mocha', '0.12.1', :require => false
end

group :production do
  # Is there an easy way to say "all platforms except :mswin, :mingw" without
  # explicitly listing all other platforms?

  gem 'libv8', '~> 3.11.8.3'
  gem 'therubyracer', '~> 0.11.0beta5', :platforms => [:ruby, :jruby] # 10.8 mountain lion compatibility

  # gem 'therubyracer', '0.10.1', :platforms => [:ruby, :jruby]
end

gem 'jquery-rails', '1.0.19'

# Use unicorn as the server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# All of the following added to lock down versions
gem 'actionmailer', '3.2.8' # was 3.1.0
gem 'actionpack', '3.2.8' # was 3.1.0
gem 'activemodel', '3.2.8' # was 3.1.0
gem 'activerecord', '3.2.8' # was 3.1.0
gem 'activeresource', '3.2.8' # was 3.1.0
gem 'activesupport', '3.2.8' # was 3.1.0
gem 'ansi', '1.4.3'
gem 'arel', '3.0.2' # was 2.2.3
gem 'bcrypt-ruby', '3.0.1'
gem 'builder', '3.0.0'
gem 'coderay', '1.0.7'
gem 'coffee-script', '2.2.0'
gem 'coffee-script-source', '1.3.3'
gem 'configatron', '2.9.1'
gem 'erubis', '2.7.0'
gem 'execjs', '1.4.0'
gem 'hashie', '1.2.0'
gem 'hike', '1.2.1'
gem 'i18n', '0.6.0'
gem 'kgio', '2.7.4'
# gem 'libv8', '3.3.10.4'
gem 'macaddr', '1.6.1'
gem 'mail', '2.4.4' # was 2.3.3
gem 'metaclass', '0.0.1'
gem 'method_source', '0.8'
gem 'mime-types', '1.19'
gem 'multi_json', '1.3.6'
gem 'orm_adapter', '0.0.7'
gem 'polyglot', '0.3.3'
gem 'rack-cache', '1.2' # was 1.0.3
gem 'rack-mount', '0.8.3'
gem 'rack-protection', '1.2.0'
gem 'rack-ssl', '1.3.2'
gem 'rack-test', '0.6.1'
gem 'railties', '3.2.8' # was 3.1.0
gem 'raindrops', '0.10.0'
gem 'rake', '0.9.2.2'
gem 'rdoc', '3.12'
gem 'redis-namespace', '1.1.0'
gem 'redisk', '0.2.2'
gem 'resque', '1.15.0'
gem 'resque-status', '0.2.4'
gem 'sass', '3.2.1'
gem 'sinatra', '1.3.0'
gem 'slop', '3.3.3'
gem 'sprockets', '2.1.3' # was 2.0.4
gem 'systemu', '2.5.2'
gem 'thor', '0.14.6'
gem 'tilt', '1.3.3'
gem 'treetop', '1.4.10'
gem 'tzinfo', '0.3.33'
gem 'uuid', '2.3.5'
gem 'vegas', '0.1.11'
gem 'warden', '1.1.1'
gem 'yamler', '0.1.0'
