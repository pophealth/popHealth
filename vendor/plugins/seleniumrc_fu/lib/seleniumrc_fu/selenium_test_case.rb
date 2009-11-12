module SeleniumrcFu
  # The Test Case class that runs your Selenium tests.
  # You are able to use all methods provided by Selenium::SeleneseInterpreter with some additions.
  class SeleniumTestCase < Test::Unit::TestCase
    module ClassMethods
      def subclasses
        @subclasses ||= []
      end

      def inherited(subclass)
        # keep a list of all subclasses on the fly, so we can run them all later from the Runner
        subclasses << subclass unless subclasses.include?(subclass)
        super
      end

      def all_subclasses_as_suite(configuration)
        suite = Test::Unit::TestSuite.new
        all_descendant_classes.each do |test_case_class|
          test_case_class.suite.tests.each do |test_case|
            test_case.configuration = configuration
            suite << test_case
          end
        end
        suite
      end

      def all_descendant_classes
        extract_subclasses(self)
      end

      def extract_subclasses(parent_class)
        classes = []
        parent_class.subclasses.each do |subclass|
          classes << subclass
          classes.push(*extract_subclasses(subclass))
        end
        classes
      end
      
      unless Object.const_defined?(:RAILS_ROOT)
        attr_accessor :use_transactional_fixtures, :use_instantiated_fixtures
      end
    end
    extend ClassMethods

    module InstanceMethods
      include SeleniumDsl
      include SeleniumCharacterizationDsl

      def setup
        #   set "setup_once" to true
        #   to prevent fixtures from being re-loaded and data deleted from the DB.
        #   this is handy if you want to generate a DB full of sample data
        #   from the tests.  Make sure none of your selenium tests manually
        #   reset data!
        # TODO: make this configurable
        setup_once = false

        raise "Cannot use transactional fixtures if ActiveRecord concurrency is turned on (which is required for Selenium tests to work)." if self.class.use_transactional_fixtures
#        @beginning = time_class.now
        unless setup_once
          begin
            ActiveRecord::Base.connection.update('SET FOREIGN_KEY_CHECKS = 0')
          rescue
            # no-op for SQLite
          end
          super
          begin
            ActiveRecord::Base.connection.update('SET FOREIGN_KEY_CHECKS = 1')
          rescue
            # no-op for SQLite
          end
        else
          unless InstanceMethods.const_defined?("ALREADY_SETUP_ONCE")
            super
            InstanceMethods.const_set("ALREADY_SETUP_ONCE", true)
          end
        end
#        puts self.class.to_s + "#" + @method_name

        @selenium = context.selenese_interpreter
      end

      def teardown
        @selenium.stop if should_stop_selenese_interpreter?
        super
        if @beginning
          duration = (time_class.now - @beginning).to_f
          puts "#{duration} seconds"
        end
      end

      def context
        @context ||= SeleniumConfiguration.instance
      end
      
      def selenium_test_case
        @selenium_test_case ||= SeleniumTestCase
      end

      def should_stop_selenese_interpreter?
        context.test_browser_mode? && (passed? || !context.keep_browser_open_on_failure)
      end

      def characterization_enabled?
        false
      end
    end
    include InstanceMethods

    self.use_transactional_fixtures = false
    self.use_instantiated_fixtures  = true
    
    def run(result, &block)
      return if @method_name.nil? || @method_name.to_sym == :default_test
      super
    end
  end
end

SeleniumTestCase = SeleniumrcFu::SeleniumTestCase
