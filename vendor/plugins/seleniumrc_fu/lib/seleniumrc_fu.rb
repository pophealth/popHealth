require 'logger'
require "stringio"

require "active_record"

#require "test/unit/ui/testrunnermediator"
#require "seleniumrc_fu/extensions/test_runner_mediator"
require 'net/http'
require 'test/unit'

require ENV["selenium_driver"] || "selenium/version_0_8_1/selenium"
require "seleniumrc_fu/extensions/selenese_interpreter"
require "seleniumrc_fu/app_server_checker"
require "seleniumrc_fu/selenium_server_runner"
require "seleniumrc_fu/mongrel_selenium_server_runner"
require "seleniumrc_fu/webrick_selenium_server_runner"
require "seleniumrc_fu/selenium_context"
require "seleniumrc_fu/selenium_configuration"
require "seleniumrc_fu/selenium_dsl"
require "seleniumrc_fu/selenium_characterization_dsl"
require "seleniumrc_fu/selenium_test_case"
require "funkytown"
require "seleniumrc_fu/tasks/selenium_test_task"
require "seleniumrc_fu/tasks/selenium_server_task"

require 'webrick_server' if self.class.const_defined? :RAILS_ROOT
