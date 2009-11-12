require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module SeleniumrcFu
describe "SeleniumTestCase", :shared => true do
  include SeleniumTestCaseSpec

  before(:each) do
    stub_selenium_configuration
    @test_case = SeleniumTestCaseSpec.test_case
    @base_selenium = mock("Base Selenium")
    @test_case.base_selenium = @base_selenium
  end

  def sample_locator
    "sample_locator"
  end

  def sample_text
    "test text"
  end

  def stub_selenium_configuration
    @context = SeleniumrcFu::SeleniumContext.new
    @context.external_app_server_host = "test.com"
    @context.external_app_server_port = 80

    SeleniumrcFu::SeleniumConfiguration.stub!(:instance).and_return(@context)
  end
end

describe SeleniumTestCase, "instance methods" do
  it_should_behave_like "SeleniumTestCase"

  it "setup should not allow transactional fixtures" do
    @test_case.class.stub!(:use_transactional_fixtures).and_return true

    expected_message = "Cannot use transactional fixtures if ActiveRecord concurrency is turned on (which is required for Selenium tests to work)."
    proc {@test_case.setup}.should raise_error(RuntimeError, expected_message)
  end
  
  it "default_timeout should be 20 seconds" do
    @test_case.default_timeout.should == 20000
  end

  it "wait_for should pass when the block returns true within time limit" do
    @test_case.wait_for(:timeout => 2) do
      true
    end
  end

  it "wait_for should raise a AssertionFailedError when block times out" do
    proc do
      @test_case.wait_for(:timeout => 2) {false}
    end.should raise_error(Test::Unit::AssertionFailedError, "Timeout exceeded (after 2 sec).")
  end

  it "wait_for_element_to_contain should pass when finding text within time limit" do
    is_element_present_results = [false, true]

    @base_selenium.should_receive(:is_element_present).any_number_of_times.
      and_return {is_element_present_results.shift}
    @base_selenium.should_receive(:get_eval).with("this.page().findElement(\"#{sample_locator}\").innerHTML").and_return(sample_text)

    @test_case.wait_for_element_to_contain(sample_locator, sample_text)
  end

  it "wait_for_element_to_contain should fail when element not found in time" do
    is_element_present_results = [false, false, false, false]

    @base_selenium.should_receive(:is_element_present).any_number_of_times.
      and_return {is_element_present_results.shift}

    proc do
      @test_case.wait_for_element_to_contain(sample_locator, "")
    end.should raise_error(Test::Unit::AssertionFailedError, "Timeout exceeded (after 5 sec).")
  end

  it "wait_for_element_to_contain should fail when text does not match in time" do
    is_element_present_results = [false, true, true, true]

    @base_selenium.should_receive(:is_element_present).any_number_of_times.
      and_return {is_element_present_results.shift}
    @base_selenium.should_receive(:get_eval).
      with("this.page().findElement(\"#{sample_locator}\").innerHTML").
      any_number_of_times.
      and_return(sample_text)

    proc do
      @test_case.wait_for_element_to_contain(sample_locator, "wrong text", nil, 1)
    end.should raise_error(Test::Unit::AssertionFailedError, "Timeout exceeded (after 1 sec).")
  end

  it "element_does_not_contain_text returns true when element is not on the page" do
    locator = "id=element_id"
    expected_text = "foobar"
    @base_selenium.should_receive(:is_element_present).with(locator).and_return(false)

    @test_case.element_does_not_contain_text(locator, expected_text).should == true
  end

  it "element_does_not_contain_text returns true when element is on page and inner_html does not contain text" do
    locator = "id=element_id"
    inner_html = "Some text that does not contain the expected_text"
    expected_text = "foobar"
    @base_selenium.should_receive(:is_element_present).with(locator).and_return(true)
    @test_case.should_receive(:get_inner_html).with(locator).and_return(inner_html)

    @test_case.element_does_not_contain_text(locator, expected_text).should == true
  end

  it "element_does_not_contain_text returns false when element is on page and inner_html does contain text" do
    locator = "id=element_id"
    inner_html = "foobar foobar foobar"
    expected_text = "foobar"
    @base_selenium.should_receive(:is_element_present).with(locator).and_return(true)
    @test_case.should_receive(:get_inner_html).with(locator).and_return(inner_html)

    @test_case.element_does_not_contain_text(locator, expected_text).should == false
  end

  it "assert_element_does_not_contain should fail when text is present in element past timeout" do
    expected_text = "foobar"
    element_does_not_contain_text_results = [false, false, false, false]

    @test_case.should_receive(:element_does_not_contain_text).
      with(sample_locator, expected_text).
      any_number_of_times.
      and_return {element_does_not_contain_text_results.shift}

    proc do
      @test_case.assert_element_does_not_contain_text(sample_locator, expected_text, "Failure Message", 1)
    end.should raise_error(Test::Unit::AssertionFailedError, "Failure Message (after 1 sec).")
  end

  it "assert_text should assert the element is present and its text is equal to that passed in" do
    expected_text = "text"

    @base_selenium.should_receive(:is_element_present).any_number_of_times.
      and_return {|locator| locator == sample_locator}
    @base_selenium.should_receive(:get_text).any_number_of_times.
      and_return(expected_text)

    @test_case.assert_text(sample_locator, expected_text)
    proc {@test_case.assert_text('locator_fails', 'hello')}.
      should raise_error(Test::Unit::AssertionFailedError)
    proc {@test_case.assert_text(sample_locator, 'goodbye')}.
      should raise_error(Test::Unit::AssertionFailedError)
  end

  it "assert_value should assert the element is present and its value is equal to that passed in" do
    expected_value = "value"

    @base_selenium.should_receive(:is_element_present).any_number_of_times.
      and_return {|locator| locator == sample_locator}
    @base_selenium.should_receive(:get_value).any_number_of_times.
      and_return(expected_value)

    @test_case.assert_value(sample_locator, expected_value)
    proc {@test_case.assert_value('locator_fails', 'hello')}.
      should raise_error(Test::Unit::AssertionFailedError)
    proc {@test_case.assert_value(sample_locator, 'goodbye')}.
      should raise_error(Test::Unit::AssertionFailedError)
  end

   it "assert_selected should assert the element is present and its selected label is equal to that passed in" do
    expected_selected = "selected"

    @base_selenium.should_receive(:is_element_present).any_number_of_times.
      and_return {|locator| locator == sample_locator}
    @base_selenium.should_receive(:get_selected_label).any_number_of_times.
      and_return(expected_selected)

    @test_case.assert_selected(sample_locator, expected_selected)
    proc {@test_case.assert_selected('locator_fails', 'hello')}.
      should raise_error(Test::Unit::AssertionFailedError)
    proc {@test_case.assert_selected(sample_locator, 'goodbye')}.
      should raise_error(Test::Unit::AssertionFailedError)
  end

  it "assert_attribute should assert if the element is present AND if the element attribute is equal to that passed in" do
    expected_attribute = "attribute"

    @base_selenium.should_receive(:is_element_present).any_number_of_times.
      and_return {|locator| locator == sample_locator}
    @base_selenium.should_receive(:get_attribute).any_number_of_times.
      and_return(expected_attribute)

    @test_case.assert_attribute(sample_locator, expected_attribute)
    proc {@test_case.assert_attribute('locator_fails', 'hello')}.
      should raise_error(Test::Unit::AssertionFailedError)
    proc {@test_case.assert_attribute(sample_locator, 'goodbye')}.
      should raise_error(Test::Unit::AssertionFailedError)
  end

  it "assert_location_ends_in should assert that the url location ends with the passed in value" do
    @base_selenium.should_receive(:get_location).any_number_of_times.
      and_return("http://home/location/1?thing=pa+ra+me+ter")

    expected_url = '/home/location/1?thing=pa+ra+me+ter'
    @test_case.assert_location_ends_in expected_url
    @test_case.assert_location_ends_in( 'location/1?thing=pa+ra+me+ter')
    @test_case.assert_location_ends_in( '1?thing=pa+ra+me+ter')
    proc {@test_case.assert_location_ends_in('the wrong thing')}.
      should raise_error(Test::Unit::AssertionFailedError)
    proc {@test_case.assert_location_ends_in('home/location')}.
      should raise_error(Test::Unit::AssertionFailedError)
  end

  it "assert_location_ends_in should not care about the order of the parameters" do
    @base_selenium.should_receive(:get_location).any_number_of_times.
      and_return("http://home/location/1?thing=parameter&foo=bar")

    @test_case.assert_location_ends_in '/home/location/1?thing=parameter&foo=bar'
    @test_case.assert_location_ends_in '/home/location/1?foo=bar&thing=parameter'
  end

  it "is_text_in_order should check if text is in order" do
    locator = "id=foo"
    @base_selenium.should_receive(:get_text).with(locator).any_number_of_times.and_return("one\ntwo\nthree\n")

    @test_case.is_text_in_order locator, "one", "two", "three"
  end

  it "should open home page" do
    @base_selenium.should_receive(:open).with("http://test.com:80").once
    @base_selenium.should_receive(:wait_for_page_to_load).with(@test_case.default_timeout).once
    @base_selenium.should_receive(:send).any_number_of_times.and_return("")

    @test_case.open_home_page
  end
end

describe SeleniumTestCase, "#assert_visible" do
  it_should_behave_like "SeleniumTestCase"

  it "fails when element is not visible" do
    @base_selenium.stub!(:is_visible).and_return {false}

    proc {
      @test_case.assert_visible("id=element")
    }.should raise_error(Test::Unit::AssertionFailedError)
  end

  it "passes when element is not visible" do
    ticks = [false, false, false, true]
    @base_selenium.stub!(:is_visible).and_return {ticks.shift}

    @test_case.assert_visible("id=element")
  end
end

describe SeleniumTestCase, "#assert_not_visible" do
  it_should_behave_like "SeleniumTestCase"

  it "fails when element is visible" do
    @base_selenium.stub!(:is_visible).and_return {true}

    proc {
      @test_case.assert_not_visible("id=element")
    }.should raise_error(Test::Unit::AssertionFailedError)
  end

  it "passes when element is visible" do
    ticks = [true, true, true, false]
    @base_selenium.stub!(:is_visible).and_return {ticks.shift}

    @test_case.assert_not_visible("id=element")
  end
end

describe SeleniumTestCase, "#type" do
  it_should_behave_like "SeleniumTestCase"

  it "types when element is present and types" do
    is_element_present_results = [false, true]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").twice.and_return {is_element_present_results.shift}
    @base_selenium.should_receive(:type).with("id=foobar", "The Text")

    @test_case.type "id=foobar", "The Text"
  end

  it "fails when element is not present" do
    is_element_present_results = [false, false, false, false]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").exactly(4).times.
      and_return {is_element_present_results.shift}
    @base_selenium.should_not_receive(:type)

    proc {
      @test_case.type "id=foobar", "The Text"
    }.should raise_error(Test::Unit::AssertionFailedError)
  end
end

describe SeleniumTestCase, "#click" do
  it_should_behave_like "SeleniumTestCase"

  it "click when element is present and types" do
    is_element_present_results = [false, true]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").twice.and_return {is_element_present_results.shift}
    @base_selenium.should_receive(:click).with("id=foobar")

    @test_case.click "id=foobar"
  end

  it "fails when element is not present" do
    is_element_present_results = [false, false, false, false]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").exactly(4).times.
      and_return {is_element_present_results.shift}
    @base_selenium.should_not_receive(:click)

    proc {
      @test_case.click "id=foobar"
    }.should raise_error(Test::Unit::AssertionFailedError)
  end
end

describe SeleniumTestCase, "#select" do
  it_should_behave_like "SeleniumTestCase"

  it "types when element is present and types" do
    is_element_present_results = [false, true]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").twice.and_return {is_element_present_results.shift}
    @base_selenium.should_receive(:select).with("id=foobar", "value=3")

    @test_case.select "id=foobar", "value=3"
  end

  it "fails when element is not present" do
    is_element_present_results = [false, false, false, false]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").exactly(4).times.
      and_return {is_element_present_results.shift}
    @base_selenium.should_not_receive(:select)

    proc {
      @test_case.select "id=foobar", "value=3"
    }.should raise_error(Test::Unit::AssertionFailedError)
  end
end

describe SeleniumTestCase, "#wait_for_and_click" do
  it_should_behave_like "SeleniumTestCase"

  it "click when element is present and types" do
    is_element_present_results = [false, true]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").twice.and_return {is_element_present_results.shift}
    @base_selenium.should_receive(:click).with("id=foobar")

    @test_case.wait_for_and_click "id=foobar"
  end

  it "fails when element is not present" do
    is_element_present_results = [false, false, false, false]
    @base_selenium.should_receive(:is_element_present).with("id=foobar").exactly(4).times.
      and_return {is_element_present_results.shift}
    @base_selenium.should_not_receive(:click)

    proc {
      @test_case.wait_for_and_click "id=foobar"
    }.should raise_error(Test::Unit::AssertionFailedError)
  end
end

describe SeleniumTestCase, "teardown" do
  it_should_behave_like "SeleniumTestCase"

  it "should not stop interpreter when tests fail if not in test browser mode" do
    @context.stub!(:test_browser_mode?).and_return(false)
    @test_case.stub!(:passed?).and_return(false)

    @base_selenium.should_receive(:stop).never
    @test_case.teardown
  end

   it "should not stop interpreter when tests pass if not in test browser mode" do
     @context.stub!(:test_browser_mode?).and_return(false)
     @test_case.stub!(:passed?).and_return(true)

     @base_selenium.should_receive(:stop).never
     @test_case.teardown
   end

  it "should stop interpreter when tests fail if in test browser mode and browser not kept open on failure" do
    @context.stub!(:test_browser_mode?).and_return(true)
    @test_case.stub!(:passed?).and_return(false)
    @context.stub!(:keep_browser_open_on_failure).and_return(false)

    @base_selenium.should_receive(:stop).once
    @test_case.teardown
  end

  it "should not stop interpreter when tests fail if in test browser mode and browser kept open on failure" do
    @context.stub!(:test_browser_mode?).and_return(true)
    @test_case.stub!(:passed?).and_return(false)
    @context.stub!(:keep_browser_open_on_failure).and_return(true)

    @base_selenium.should_receive(:stop).never
    @test_case.teardown
  end

  it "should stop interpreter when in test browser mode and tests pass" do
    @context.stub!(:test_browser_mode?).and_return(true)
    @test_case.stub!(:passed?).and_return(true)

    @base_selenium.should_receive(:stop).once
    @test_case.teardown
  end
end

describe SeleniumTestCase, "characterization methods" do
  it_should_behave_like "SeleniumTestCase"

  before(:each) do
    @characterization_case = SeleniumTestCaseSpec.characterization_case
    @base_selenium = mock("Base Selenium")
    @characterization_case.base_selenium = @base_selenium
  end

  it "by default, answers false for #characterization_enabled?" do
    @test_case.characterization_enabled?.should == false
  end
  
  it "by default, does not call Dispatcher.dispatch(...) on wait_for" do
    SeleniumrcFu::SeleniumCharacterization::Dispatcher.should_receive(:dispatch).never
    @test_case.wait_for(:timeout => 2) do
      true
    end
  end
  
  it "when SeleniumCharacterization has been included, answers true for #characterization_enabled?" do
    @characterization_case.characterization_enabled?.should == true
  end
  
  it "when SeleniumCharacterization has been included, calls Dispatcher.dispatch(...) on wait_for" do
    SeleniumrcFu::SeleniumCharacterization::Dispatcher.should_receive(:dispatch).once
    @characterization_case.wait_for(:timeout => 2) do
      true
    end
  end
end

end
