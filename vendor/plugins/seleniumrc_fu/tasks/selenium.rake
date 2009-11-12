require File.dirname(__FILE__) + "/loadpath_bootstrap"

# =============================================================================
# custom tasks for running selenium
# =============================================================================

namespace :selenium do
  desc "Run the selenium tests in Firefox"
  task :test_with_server_started do
    require "seleniumrc_fu/tasks/selenium_test_task"
    task = SeleniumrcFu::Tasks::SeleniumTestTask.new(RAILS_ENV, RAILS_ROOT)
    task.invoke(ENV['test'] || "test/selenium/selenium_suite")
  end

  desc "Run the selenium remote-control server"
  task :server do
    require "seleniumrc_fu/tasks/selenium_server_task"
    task = SeleniumrcFu::Tasks::SeleniumServerTask.new(ENV['selenium_server_jar'])
    task.invoke
  end

  desc "Run the selenium servant in the foreground"
  task :run_server do
    require "seleniumrc_fu/tasks/selenium_server_task"
    task = SeleniumrcFu::Tasks::SeleniumServerTask.new(ENV['selenium_server_jar'], false)
    task.invoke
  end

  desc "Start the selenium servant (the server that launches browsers) on localhost"
  task :start_servant do
    require "funkytown/selenium_task"
    Funkytown::SeleniumTask.new.start_servant
  end

  desc "Stop the selenium servant (the server that launches browsers) on localhost"
  task :stop_servant do
    require "funkytown/selenium_task"
    Funkytown::SeleniumTask.new.stop_servant
  end

  desc "Stop and start the selenium servant (the server that launches browsers) on localhost"
  task :restart_servant => [:stop_servant, :start_servant]

  desc "Run a selenium test file (default test/selenium/selenium_suite)"
  task :test do
    require "funkytown/selenium_task"
    Funkytown::SeleniumTask.new.run_test(ENV['test'] || "test/selenium/selenium_suite")
  end
  
  namespace :characterize do
    desc "Run a selenium test file in the 'store' characterization mode"
    task :store do
      require "funkytown/selenium_task"
      ENV['characterization_mode'] = 'store'
      Funkytown::SeleniumTask.new.run_test(ENV['test'] || "test/selenium/selenium_suite")
    end

    desc "Run a selenium test file in the 'compare' characterization mode"
    task :compare do
      require "funkytown/selenium_task"
      ENV['characterization_mode'] = 'compare'
      Funkytown::SeleniumTask.new.run_test(ENV['test'] || "test/selenium/selenium_suite")
    end
  end
end

