require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe Test::Unit::UI::TestRunnerMediator do
  before do
    @context = SeleniumrcFu::SeleniumContext.new
    @mediator = Object.new
    @mediator.extend Test::Unit::UI::TestRunnerMediator::InstanceMethodsForSeleniumIntegration
    @mock_result = mock_result = mock("mock_result")
    @mediator.stub!(:old_run_suite_for_selenium).and_return(mock_result)

    @mediator.extend Test::Unit::UI::TestRunnerMediator::ClassMethodsForSeleniumIntegration
    @mediator.selenium_context = @context

    @context.browsers = ["firefox"]

    @mock_app_server_checker = mock_app_server_checker = mock("mock_app_server_checker")
    @context.stub!(:create_app_server_checker).and_return(mock_app_server_checker)
  end

  it "when server not started should start runner" do
    @mock_app_server_checker.should_receive(:is_server_started?).and_return(false)
    @mock_result.should_receive(:passed?).and_return(true)
    mock_server_runner = mock("mock_server_runner")
    @context.stub!(:create_server_runner).and_return(mock_server_runner)
    mock_server_runner.should_receive(:start)
    @mediator.run_suite
  end

  it "should notify before_suite callbacks" do
    @mock_app_server_checker.should_receive(:is_server_started?).and_return(true)
    @mock_result.should_receive(:passed?).and_return(true)
    before_suite_called = false
    @context.before_suite {before_suite_called = true}
    @mediator.run_suite
    before_suite_called.should == true
  end
end