require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

context "MongrelSeleniumServerRunner instance" do
  setup do
    @context = SeleniumrcFu::SeleniumContext.new
  end

  specify "starts server" do
    runner = create_runner_for_start_server
    runner.stub!(:initialize_server)
    @runner.start
  end

  specify "start_server initializes server" do
    @runner = create_runner_for_start_server

    @mock_configurator.should_receive(:listener).and_yield(@mock_configurator)

    @runner.stub!(:defaults).and_return({:environment => ""})
    fake_rails = Object.new

    @mock_configurator.should_receive(:rails).once.and_return(fake_rails)
    @mock_configurator.should_receive(:uri).with("/", {:handler => fake_rails})
    @mock_configurator.should_receive(:load_plugins).once
    @runner.start
  end

  def create_runner_for_start_server
    @mock_configurator = mock_configurator = mock("mock_configurator")
    @context.stub!(:create_mongrel_configurator).and_return(mock_configurator)
    @runner = @context.create_mongrel_runner

    @mock_configurator.should_receive(:run)
    @mock_configurator.should_receive(:log).any_number_of_times
    @mock_configurator.should_receive(:join)

    mock_thread_class = mock("mock_thread_class")
    @runner.thread_class = mock_thread_class
    mock_thread_class.should_receive(:start).and_yield
    @runner
  end
end