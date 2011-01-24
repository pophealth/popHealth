# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'
#require 'rspec/core/rake_task'

PopHealth::Application.load_tasks

ENV['DB_NAME'] = "pophealth-#{Rails.env}"

require 'qme_test'

#RSpec::Core::RakeTask.new do |t|
#  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
#  t.pattern = 'spec/**/*_spec.rb'
#end

