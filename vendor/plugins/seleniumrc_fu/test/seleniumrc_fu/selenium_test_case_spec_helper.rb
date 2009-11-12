require 'seleniumrc_fu/selenium_characterization'

module SeleniumTestCaseSpec
  def self.test_case
    self.prepare_test_case(MySeleniumTestCase.new)
  end
  
  def self.characterization_case
    self.prepare_test_case(MySeleniumCharacterizationCase.new)
  end
  
  def self.prepare_test_case(test_case)
    time = Time.now
    time_class = Spec::Mocks::Mock.new('time_class', {})
    time_class.should_receive(:now).any_number_of_times.and_return { time += 1 }
    test_case.stub!(:time_class).and_return time_class
    test_case.stub!(:sleep).and_return
    test_case
  end

  class MySeleniumTestCase < SeleniumrcFu::SeleniumTestCase
    def initialize(*args)
      @_result = Test::Unit::TestResult.new
      super('test_nothing')
    end

    def run(result)
      # do nothing
    end
    def test_nothing
    end

    def base_selenium
      @selenium
    end
    def base_selenium=(value)
      @selenium = value
    end
  end
  
  class MySeleniumCharacterizationCase < MySeleniumTestCase
    include SeleniumrcFu::SeleniumCharacterization
  end
end
