require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module SeleniumrcFu
describe WebrickSeleniumServerRunner do
  before(:each) do
    Object.const_set(:RAILS_ROOT, "foobar")
  end

  after(:each) do
    Object.instance_eval {remove_const :RAILS_ROOT}
  end

  it "start method should set socket.do_not_reverse_lookup to true and" do
    runner = create_runner_that_is_stubbed_so_start_method_works
    runner.start
  end

  it "start method should initialize the HttpServer with parameters" do
    runner = create_runner_that_is_stubbed_so_start_method_works
    runner.start
  end

  it "start method should mount and start the server" do
    runner = create_runner_that_is_stubbed_so_start_method_works
    runner.start
  end

  it "start method should require the environment and dispatcher" do
    runner = create_runner_that_is_stubbed_so_start_method_works

    runner.should_receive(:require).with("foobar")
    runner.should_receive(:require).with("dispatcher")

    runner.environment_path = "foobar"
    runner.start
  end

  it "start method should require environment when rails_root is not set" do
    runner = create_runner_that_is_stubbed_so_start_method_works
    requires = []
    runner.should_receive(:require).any_number_of_times.and_return {|val| requires << val}

    runner.start
    requires.any? {|r| r =~ /\/config\/environment/}.should == true
  end

  it "start method should trap server.shutdown" do
    runner = create_runner_that_is_stubbed_so_start_method_works

    (class << runner; self; end).class_eval {attr_reader :trap_signal_name}
    def runner.trap(signal_name, &block)
      @trap_signal_name = signal_name
      block.call
    end
    @mock_server.should_receive(:shutdown).once

    runner.start
    runner.trap_signal_name.should == "INT"
  end

  it "should shutdown webrick server" do
    runner = create_runner_that_is_stubbed_so_start_method_works
    runner.start
    @mock_server.should_receive(:shutdown).once
    runner.stop
  end

  def create_runner_that_is_stubbed_so_start_method_works()
    @context = SeleniumrcFu::SeleniumContext.new
    runner = @context.create_webrick_runner
    class << runner; public :start_server; end

    def runner.require(*args)
    end

    mock_socket = mock("mock_socket")
    runner.socket = mock_socket
    mock_socket.
      should_receive(:do_not_reverse_lookup=).
      with(true).
      once

    @mock_server = mock_server = mock("mock_server")
    (class << @context; self; end).class_eval do
      define_method :create_webrick_server do
        mock_server
      end
    end

    @context.internal_app_server_port = 4000
    @context.internal_app_server_host = "localhost"
    @context.rails_env = "test"
    @mock_server.
      should_receive(:mount).
      once.
      with('/', DispatchServlet, {
        :port            => @context.internal_app_server_port,
        :ip              => @context.internal_app_server_host,
        :environment     => @context.rails_env,
        :server_root     => File.expand_path("#{@context.rails_root}/public/"),
        :server_type     => WEBrick::SimpleServer,
        :charset         => "UTF-8",
        :mime_types      => WEBrick::HTTPUtils::DefaultMimeTypes,
        :working_directory => File.expand_path(@context.rails_root.to_s)
      })

    @mock_server.should_receive(:start).once

    mock_thread_class = mock("mock_thread_class")
    runner.thread_class = mock_thread_class
    mock_thread_class.
      should_receive(:start).
      once.
      and_return {|block| block.call}

    return runner
  end

end
end
