require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module SeleniumrcFu
  context SeleniumConfiguration do
    before(:each) do
      SeleniumrcFu::SeleniumConfiguration.instance_eval {@context = nil}
      @mock_context = mock("context")
    end

    it "should create a new context if it hasn't been called yet" do
      SeleniumrcFu::SeleniumContext.should_receive(:new).and_return(@mock_context)
      @mock_context.should_receive(:establish_environment).exactly(1).times
      SeleniumrcFu::SeleniumConfiguration.instance.should == @mock_context
    end

    it "should reuse the existing context if it has been called.  So new/establish_environment should only be called once." do
      SeleniumrcFu::SeleniumContext.should_receive(:new).exactly(1).times.and_return(@mock_context)
      @mock_context.should_receive(:establish_environment).exactly(1).times
      SeleniumrcFu::SeleniumConfiguration.instance.should == @mock_context
      SeleniumrcFu::SeleniumConfiguration.instance.should == @mock_context
    end
  end
end
