# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# Ensure that Saxon is used for running XSLT. For this to work, the Saxon jars must be included in the
# CLASSPATH environment variable. Using require to pull them in does not seem to work.
java.lang.System.setProperty("javax.xml.transform.TransformerFactory","net.sf.saxon.TransformerFactoryImpl")
java.lang.System.setProperty("javax.xml.parsers.DocumentBuilderFactory","net.sf.saxon.dom.DocumentBuilderFactoryImpl")

# XXX ActiveRecord extensions need to be loaded first, otherwise some
# operations that utilize AR during init will fail. There's probably a
# better way to do this.
require 'activerecord'
require_dependency 'has_select_options'
require_dependency 'has_c32_component'
require_dependency 'find_random'

class ActiveRecord::Base
  extend HasSelectOptionsExtension
  extend HasC32ComponentExtension
  extend FindRandom
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
  # See Rails::Configuration for more options.

  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Only load the plugins named here, in the order given. By default, all plugins 
  # in vendor/plugins are loaded in alphabetical order.
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  # config.action_controller.session = {
  #  :session_key => '_laika_session',
  #  :secret      => '451d52461398c0186576b60fc40b9c8304fb1b38a8f6dce0e6ec564fc7c16687db8d468681bc7053901c56c6ae2e2e394a7631e9f95ea52b4fc69d0e6e5a58a2'
  # }

  # Use the database for sessions instead of the cookie-based default,
  # which shouldn't be used to store highly confidential information
  # (create the session table with 'rake db:sessions:create')
  config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper,
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector
  config.active_record.observers = :user_observer

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc

  # These are dependencies we need to run the application.
  config.gem 'faker',                :version => '0.3.1'
  config.gem 'calendar_date_select', :version => '1.15'
  config.gem 'mislav-will_paginate', :version => '>= 2.3.6', :lib => 'will_paginate', :source => 'http://gems.github.com'
  #config.gem 'CCHIT-xds-facade', :lib => 'xds-facade', :version => '>= 0.1.1', :source => 'http://gems.github.com'

  # These are dependencies for the tests.
  # We just want to make sure they're available without loading them.
  config.gem 'rspec',       :lib => false, :version => '>= 1.2.2'
  config.gem 'rspec-rails', :lib => false, :version => '>= 1.2.2'

  config.gem 'state_machine'

  # Setting a default timezone, please change this to where ever you are deployed
  config.time_zone = "Eastern Time (US & Canada)"
end

ENV['HOST_URL'] = 'http://demo.cchit.org/laika'
ENV['HELP_LIST'] = 'talk@projectlaika.org'

ActionMailer::Base.smtp_settings = {
  :address => "mail.mitre.org",
  :port => 25,
  :domain => "mitre.org",
}

