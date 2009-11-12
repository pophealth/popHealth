require File.dirname(__FILE__) + "/loadpath_bootstrap"

desc "Runs a JSUnit test or suite.  Specify with TEST=[name|path]"
task :jsunit => ["jsunit:test"]

namespace :jsunit do
  desc "Start the jsunit servant (the server that launches browsers) on localhost"
  task :start_servant do
    require "funkytown/jsunit_task"
    Funkytown::JsunitTask.new.start_servant
  end

  desc "Stop the jsunit servant (the server that launches browsers) on localhost"
  task :stop_servant do
    require "funkytown/jsunit_task"
    Funkytown::JsunitTask.new.stop_servant
  end

  desc "Stop and start the jsunit servant (the server that launches browsers) on localhost"
  task :restart_servant => [:stop_servant, :start_servant]

  desc "Run the suite of jsunit tests"
  task :suite => :start_servant do
    require "funkytown/jsunit_task"
    Funkytown::JsunitTask.new.run_test or raise "JsUnit Failure"
  end

  task :test => :start_servant do
    require "funkytown/jsunit_task"
    Funkytown::JsunitTask.new.run_test(ENV['TEST'] || nil) or raise "JsUnit failed"
  end

end
