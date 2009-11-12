# Expand the path to environment so that Ruby does not load it multiple times
# File.expand_path can be removed if Ruby 1.9 is in use.
require "test/unit/ui/testrunnermediator"
require "seleniumrc_fu/extensions/test_runner_mediator"
require "seleniumrc_fu"

context = SeleniumrcFu::SeleniumConfiguration.instance
Test::Unit::UI::TestRunnerMediator.selenium_context = context
context.after_selenese_interpreter_started do |interpreter|
  interpreter.insert_javascript_file("/selenium/user-extensions.js")
  interpreter.insert_plugin_javascript(context.rails_root, File.join(File.dirname(__FILE__), 'selenium_characterization/css_characterizer.js'))
end

