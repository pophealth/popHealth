require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module Selenium
describe SeleneseInterpreter do
  it "initializes with defaults" do
    @interpreter = Selenium::SeleneseInterpreter.new("localhost", 4444, "*iexplore", "localhost:3000")

    @interpreter.server_host.should == "localhost"
    @interpreter.server_port.should == 4444
    @interpreter.browser_start_command.should == "*iexplore"
    @interpreter.browser_url.should == "localhost:3000"
    @interpreter.timeout_in_milliseconds.should == 30000
  end

  it "should start" do
    @interpreter = Selenium::SeleneseInterpreter.new("localhost", 4444, "*iexplore", "localhost:3000")

    @interpreter.should_receive(:do_command).
      with("getNewBrowserSession", ["*iexplore", "localhost:3000"]).and_return("   12345")

    @interpreter.start
    @interpreter.instance_eval {@session_id}.should == "12345"
  end
end
end
