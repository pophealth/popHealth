#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake/dsl_definition'
require 'rake'
# require 'rspec/core/rake_task'
# require 'resque/tasks'

PopHealth::Application.load_tasks

ENV['DB_NAME'] = "pophealth-#{Rails.env}"

Rake::TestTask.new(:test_unit) do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose = true
end


task :test => [:test_unit] do
  system("open coverage/index.html")
end