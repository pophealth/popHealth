class Test::Unit::UI::TestRunnerMediator
  module ClassMethodsForSeleniumIntegration
    attr_accessor :selenium_context
  end
  extend ClassMethodsForSeleniumIntegration

  module InstanceMethodsForSeleniumIntegration
    unless method_defined?(:old_run_suite_for_selenium)
      def run_suite
        result = nil
        selenium_context.run_each_browser do
          result = run_suite_within_browser
        end
        result
      end

      private
      def run_suite_within_browser
        app_server_checker = selenium_context.create_app_server_checker
        server_started = app_server_checker.is_server_started?
        setup_selenium unless server_started
        selenium_context.notify_before_suite
        result = old_run_suite_for_selenium
        selenium_context.stop_interpreter_if_necessary(result.passed?)
        return result
      end

      def setup_selenium
        puts "Running #{selenium_context.formatted_browser}..."
        @server_runner = selenium_context.create_server_runner
        @server_runner.start
      end

      def selenium_context
        self.class.selenium_context
      end
    end
  end

  # TODO: This needs to be refactored and cleaned up - should consolidate Test::Unit hooks in one place
  if method_defined?(:run_suite_with_hooks)
    alias_method :old_run_suite_for_selenium, :run_suite_with_hooks
  else
    alias_method :old_run_suite_for_selenium, :run_suite
    remove_method(:run_suite)
  end
  include InstanceMethodsForSeleniumIntegration
end
