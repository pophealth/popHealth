require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module SeleniumrcFu
describe SeleniumServerRunner do
  before(:each) do
    @runner = SeleniumrcFu::SeleniumServerRunner.new
    class << @runner
      public :start_server, :stop_server
    end
  end

  it "should initialize started? to be false" do
    @runner.started?.should ==  false
  end

  it "start method should start new thread and set started" do
    start_server_called = false
    (class << @runner; self; end).class_eval do
      define_method :start_server do; start_server_called = true; end
    end
    def @runner.stop_server; end
    mock_thread_class = mock("mock_thread_class")
    mock_thread_class.
      should_receive(:start).
      once.
      and_return {|block| block.call}
    @runner.thread_class = mock_thread_class

    @runner.start
    start_server_called.should equal(true)
    @runner.started?.should equal(true)
  end

  it "stop method should set started? to false" do
    def @runner.stop_server; end
    @runner.instance_eval {@started = true}
    @runner.stop
    @runner.started?.should ==  false
  end

  it "start_server method should raise a NotImplementedError by default" do
    proc {@runner.start_server}.should raise_error(NotImplementedError)
  end
end
end
