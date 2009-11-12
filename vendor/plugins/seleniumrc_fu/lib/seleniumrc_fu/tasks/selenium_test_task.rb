module SeleniumrcFu
  module Tasks
    class SeleniumTestTask
      attr_reader :rails_env, :rails_root

      def initialize(rails_env = RAILS_ENV, rails_root = RAILS_ROOT)
        @rails_env = rails_env
        @rails_root = rails_root
      end

      def invoke(suite_relative_path = "test/selenium/selenium_suite")
        rails_env.replace "test"
        require "#{rails_root}/" + suite_relative_path

        passed = Test::Unit::AutoRunner.run
        raise "Test failures" unless passed
      end
    end
  end
end