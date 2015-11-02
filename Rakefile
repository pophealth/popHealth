#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake/dsl_definition'
require 'rake'
# require 'rspec/core/rake_task'
# require 'resque/tasks'

# This fixes errors in the delayed job where the log file will not be written to 
# until the delayed job exits.
STDOUT.sync = true

PopHealth::Application.load_tasks

ENV['DB_NAME'] = "pophealth-#{Rails.env}"

Rake::TestTask.new(:test_unit) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end

task :test_all => ["jasmine:ci", :test_unit] do
  system("open coverage/index.html")
end

Rake::Task["test"].clear
task 'test' do
  puts "Please run rake test_all in order to run the test suite."
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
