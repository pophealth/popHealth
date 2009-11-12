require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module SeleniumrcFu
describe SeleniumContext do
  before(:each) do
    @context = SeleniumrcFu::SeleniumContext.new
    @old_rails_root = RAILS_ROOT if Object.const_defined? :RAILS_ROOT
    silence_warnings { Object.const_set :RAILS_ROOT, "foobar" }
    require 'webrick_server'
  end

  after(:each) do
    if @old_rails_root
      silence_warnings { Object.const_set :RAILS_ROOT, @old_rails_root }
    else
      Object.instance_eval {remove_const :RAILS_ROOT}
    end
  end

  it "registers and notifies before_suite callbacks" do
    proc1_called = false
    proc1 = lambda {proc1_called = true}
    proc2_called = false
    proc2 = lambda {proc2_called = true}

    @context.before_suite(&proc1)
    @context.before_suite(&proc2)
    @context.notify_before_suite
    proc1_called.should == true
    proc2_called.should == true
  end

  it "registers and notifies after_selenese_interpreter_started callbacks" do
    proc1_args = nil
    proc1 = lambda {|*args| proc1_args = args}
    proc2_args = nil
    proc2 = lambda {|*args| proc2_args = args}

    @context.after_selenese_interpreter_started(&proc1)
    @context.after_selenese_interpreter_started(&proc2)

    expected_interpreter = Object.new
    @context.notify_after_selenese_interpreter_started(expected_interpreter)
    proc1_args.should == [expected_interpreter]
    proc2_args.should == [expected_interpreter]
  end

  it "creates app server checker" do
    app_server_checker = @context.create_app_server_checker
    app_server_checker.context.should == @context
    app_server_checker.tcp_socket_class.should == TCPSocket
  end

  it "defaults to true for verify_remote_app_server_is_running" do
    @context.verify_remote_app_server_is_running.should ==  true
  end

  it "creates a Selenese interpreter and notify listeners" do
    @context.selenium_server_host = "selenium_server_host.com"
    @context.selenium_server_port = 80
    @context.current_browser = "iexplore"
    @context.external_app_server_host = "browser_host.com"
    @context.external_app_server_port = 80

    interpreter = @context.create_interpreter
    interpreter.server_host.should == "selenium_server_host.com"
    interpreter.server_port.should == 80
    interpreter.browser_start_command.should == "*iexplore"
    interpreter.browser_url.should == "http://browser_host.com:80"
  end

  it "creates, initializes. and notifies listeners for a Selenese interpreter " do
    passed_interpreter = nil
    @context.after_selenese_interpreter_started {|interpreter| passed_interpreter = interpreter}

    stub_interpreter = Object.new
    start_called = false
    stub_interpreter.stub!(:start).and_return {start_called = true}
    @context.stub!(:create_interpreter).and_return {stub_interpreter}
    interpreter = @context.create_and_initialize_interpreter
    interpreter.should == stub_interpreter
    passed_interpreter.should == interpreter
    start_called.should == true
  end

  it "creates a Webrick Server Runner" do
    @context.selenium_server_port = 4000
    @context.selenium_server_host = "localhost"
    dir = File.dirname(__FILE__)
    @context.rails_root = dir
    @context.rails_env = "test"

    runner = @context.create_webrick_runner
    runner.should be_an_instance_of(SeleniumrcFu::WebrickSeleniumServerRunner)
    runner.context.should == @context
    runner.thread_class.should == Thread
    runner.socket.should == Socket
    runner.dispatch_servlet.should == DispatchServlet
    runner.environment_path.should == File.expand_path("#{dir}/config/environment")
  end

  it "creates webrick http server" do
    @context.internal_app_server_port = 4000
    @context.internal_app_server_host = "localhost"

    mock_logger = mock("logger")
    @context.should_receive(:new_logger).and_return(mock_logger)
    WEBrick::HTTPServer.should_receive(:new).with({
      :Port => 4000,
      :BindAddress => "localhost",
      :ServerType  => WEBrick::SimpleServer,
      :MimeTypes => WEBrick::HTTPUtils::DefaultMimeTypes,
      :Logger => mock_logger,
      :AccessLog => []
    })
    server = @context.create_webrick_server
  end

  it "creates Mongrel Server Runner" do
   server = @context.create_mongrel_runner
   server.should be_instance_of(SeleniumrcFu::MongrelSeleniumServerRunner)
   server.context.should == @context
   server.thread_class.should == Thread
  end

  it "creates Mongrel configurator" do
    @context.internal_app_server_host = "localhost"
    @context.internal_app_server_port = 4000
    @context.rails_env = "test"
    @context.rails_root = File.dirname(__FILE__)

    configurator = @context.create_mongrel_configurator
    configurator.defaults[:host].should == "localhost"
    configurator.defaults[:port].should == 4000
    configurator.defaults[:cwd].should == @context.rails_root
    configurator.defaults[:log_file].should == "#{@context.rails_root}/log/mongrel.log"
    configurator.defaults[:pid_file].should == "#{@context.rails_root}/log/mongrel.pid"
    configurator.defaults[:environment].should == "test"
    configurator.defaults[:docroot].should == "public"
    configurator.defaults[:mime_map].should be_nil
    configurator.defaults[:daemon].should == false
    configurator.defaults[:debug].should == false
    configurator.defaults[:includes].should == ["mongrel"]
    configurator.defaults[:config_script].should be_nil
  end
end

describe SeleniumContext, "establish_environment" do
  setup do
    @context = SeleniumContext.new
  end

  specify "should handle internal_app_server_host env variable" do
    @context.establish_environment({"internal_app_server_host" => '192.168.10.1'})
    @context.internal_app_server_host.should == '192.168.10.1'
  end

  specify "should handle internal_app_server_port env variable" do
    @context.establish_environment({"internal_app_server_port" => 1337})
    @context.internal_app_server_port.should == 1337
  end

  specify "should handle external_app_server_port env variable" do
    @context.establish_environment({"external_app_server_port" => 1337})
    @context.external_app_server_port.should == 1337
  end

  specify "should handle internal_app_server_host env variable" do
    @context.establish_environment({"external_app_server_host" => 'sammich.com'})
    @context.external_app_server_host.should == "sammich.com"
  end

  specify "should handle selenium_server_host env variable" do
    @context.establish_environment({"selenium_server_host" => 'sammich.com'})
    @context.selenium_server_host.should == "sammich.com"
  end

  specify "should handle selenium_server_port env variable" do
    @context.establish_environment({"selenium_server_port" => 1337})
    @context.selenium_server_port.should == 1337
  end

  specify "should handle app_server_engine env variable" do
    @context.establish_environment({"app_server_engine" => :webrick})
    @context.app_server_engine.should == :webrick
  end

  specify "should handle browsers env variable (and convert it to an array)" do
    @context.establish_environment({"browsers" => "konqueror"})
    @context.browsers.should == ["konqueror"]
  end

  specify "should handle keep_browser_open_on_failure env variable (and convert it to a boolean)" do
    @context.establish_environment({"keep_browser_open_on_failure", "false"})
    @context.keep_browser_open_on_failure.should == false

    @context.establish_environment({"keep_browser_open_on_failure", "true"})
    @context.keep_browser_open_on_failure.should == true

    @context.establish_environment({"keep_browser_open_on_failure", "blah"})
    @context.keep_browser_open_on_failure.should == true
  end

  specify "should handle verify_remote_app_server_is_running env variable (and convert it to a boolean)" do
    @context.establish_environment({"verify_remote_app_server_is_running", "false"})
    @context.verify_remote_app_server_is_running.should == false

    @context.establish_environment({"verify_remote_app_server_is_running", "true"})
    @context.verify_remote_app_server_is_running.should == true

    @context.establish_environment({"verify_remote_app_server_is_running", "blah"})
    @context.verify_remote_app_server_is_running.should == true
  end
end

describe SeleniumContext, "initializing" do
  setup do
    @context = SeleniumContext.new
  end

  specify "internal_app_server_host" do
    should_lazily_load :internal_app_server_host, "0.0.0.0"
  end

  specify "internal_app_server_port" do
    should_lazily_load :internal_app_server_port, 4000
  end

  specify "external_app_server_host" do
    should_lazily_load :external_app_server_host, "localhost"
  end

  specify "external_app_server_port" do
    should_lazily_load :external_app_server_port, 4000
  end

  specify "browsers__lazy_loaded" do
    should_lazily_load :browsers, [SeleniumrcFu::SeleniumContext::FIREFOX]
  end

  specify "keep_browser_open_on_failure" do
    should_lazily_load :keep_browser_open_on_failure, true
  end

  def should_lazily_load(method_name, default_value)
    @context.send(method_name).should == default_value
    test_object = Object.new
    @context.send(method_name.to_s + "=", test_object)
    @context.send(method_name).should == test_object
  end
end

describe SeleniumContext do
  before do
    @context = SeleniumContext.new
  end

  specify "formatted_browser" do
    @context.current_browser = SeleniumrcFu::SeleniumContext::IEXPLORE
    @context.formatted_browser.should == "*iexplore"
  end

  specify "browser_url" do
    @context.external_app_server_host = "test.com"
    @context.external_app_server_port = 101
    @context.browser_url.should == "http://test.com:101"
  end

  specify "run_each_browser_within_the_browsers" do
    expected_browsers = ["iexplore", "firefox", "custom"]
    @context.browsers = expected_browsers

    index = 0
    @context.run_each_browser do
      @context.current_browser.should == expected_browsers[index]
      index += 1
    end
  end

  specify "selenese_interpreter__when_in_test_browser_mode__should_be_nil" do
    @context.test_browser_mode!
    @context.selenese_interpreter.should be_nil
  end
end

describe SeleniumContext, "#create_server_runner where application server engine is mongrel" do
  it "creates a mongrel server runner" do
    context = SeleniumrcFu::SeleniumContext.new
    context.app_server_engine = :mongrel
    runner = context.create_server_runner
    runner.should be_instance_of(MongrelSeleniumServerRunner)
  end
end

describe SeleniumContext, "#create_server_runner where application server engine is webrick" do
  before do
    Object.const_set :RAILS_ROOT, "foobar"
    require 'webrick_server'
  end

  after do
    Object.instance_eval {remove_const :RAILS_ROOT}
  end

  it "creates a webrick server runner" do
    context = SeleniumrcFu::SeleniumContext.new
    context.app_server_engine = :webrick
    runner = context.create_server_runner
    runner.should be_instance_of(WebrickSeleniumServerRunner)
  end
end
end
