require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module SeleniumrcFu
describe AppServerChecker, "on local host" do
  before(:each) do
    @context = SeleniumrcFu::SeleniumContext.new
    @host = "0.0.0.0"
    @context.internal_app_server_host = @host
    @port = 4000
    @context.internal_app_server_port = @port
    @app_server_checker = @context.create_app_server_checker
    @mock_tcp_socket_class = mock('mock_tcp_socket_class')
    @app_server_checker.tcp_socket_class = @mock_tcp_socket_class
    @expected_translated_local_host_address = "127.0.0.1"
  end

  it "returns true for is_server_started? if server is running" do
    @mock_tcp_socket_class.should_receive(:new).with(@expected_translated_local_host_address, @port)
    @app_server_checker.is_server_started?.should == (true)
  end

  it "returns false for is_server_started? if server is NOT running" do
    @mock_tcp_socket_class.should_receive(:new).with(@expected_translated_local_host_address, @port).and_raise(SocketError)
    @app_server_checker.is_server_started?.should == (false)
  end
end

describe AppServerChecker, "on remote host" do
  before(:each) do
    @context = SeleniumrcFu::SeleniumContext.new
    @host = "some-remote-host"
    @context.internal_app_server_host = @host
    @port = 4000
    @context.internal_app_server_port = @port
    @app_server_checker = @context.create_app_server_checker
    @mock_tcp_socket_class = mock('mock_tcp_socket_class')
    @app_server_checker.tcp_socket_class = @mock_tcp_socket_class
  end

  it "returns true for is_server_started? if verify_remote_app_server_is_running_flag is false" do
    @context.verify_remote_app_server_is_running = false
    @app_server_checker.is_server_started?.should == (true)
  end

  it "returns true for is_server_started? if server is running" do
    @mock_tcp_socket_class.should_receive(:new).with(@host, @port)
    @app_server_checker.is_server_started?.should == (true)
  end

  it "raises exception if server is NOT running and verify_remote_app_server_is_running_flag is true" do
    @context.verify_remote_app_server_is_running = true
    @mock_tcp_socket_class.should_receive(:new).with(@host, @port).and_raise(SocketError)
    lambda {@app_server_checker.is_server_started?}.should raise_error(RuntimeError)
  end
end
end
