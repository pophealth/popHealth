require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

describe "Basic selenium task setup", :shared => true do
  before do
    @rails_root = "railsroot"
    @rails_env = "originalrailsenv"
    @env = {}
    @task = Funkytown::SeleniumTask.new(@rails_env, @rails_root, @env, :disable_requirement_checking => true)
    @sayings = []
    @task.should_receive(:say).any_number_of_times.and_return do |msg|
      @sayings << msg
    end
  end
end

describe "A selenium task running run_test" do
  it_should_behave_like "Basic selenium task setup"

  it "should check servants, check if the test file exists, and make the rails env correct before going" do
    @task.stub!(:run_test_on_servant_browsers).and_return(true)
    
    @task.should_receive(:check_servants).once
    @task.should_receive(:check_if_test_file_exists).once
    @task.run_test
    @rails_env.should == "test"
  end

  it "should run tests on each servant host" do
    @task.stub!(:servant_hosts).and_return(["localhost", "another"])
    @task.stub!(:check_servants)
    @task.stub!(:check_if_test_file_exists).and_return("test/selenium/selenium_suite")

    @task.should_receive(:run_test_on_servant_browsers).ordered.with("test/selenium/selenium_suite", "localhost").and_return(true)
    @task.should_receive(:run_test_on_servant_browsers).ordered.with("test/selenium/selenium_suite", "another").and_return(true)
    @task.run_test
  end

  it "should raise errors if any servant host fails, but run everything anyway" do
    @task.stub!(:servant_hosts).and_return(["localhost", "another"])
    @task.stub!(:check_servants)
    @task.stub!(:check_if_test_file_exists).and_return("test/selenium/selenium_suite")

    @task.should_receive(:run_test_on_servant_browsers).ordered.with("test/selenium/selenium_suite", "localhost").and_return(false)
    @task.should_receive(:run_test_on_servant_browsers).ordered.with("test/selenium/selenium_suite", "another").and_return(true)
    lambda {@task.run_test}.should raise_error(RuntimeError, "ERROR : Selenium had failed tests")
  end

  it "should pass test name to run_test_on_servant_browsers" do
    @task.stub!(:check_servants)
    @task.stub!(:check_if_test_file_exists).and_return("test/selenium/my_suite")
    @task.should_receive(:run_test_on_servant_browsers).once.with("test/selenium/my_suite", "localhost").and_return(true)
    @task.run_test("test/selenium/my_suite")
  end
end

describe "A selenium task running check_if_test_file_exists" do
  it_should_behave_like "Basic selenium task setup"

  it "should detect if the test of interest is working" do
    File.should_receive(:exist?).with("railsroot/mytestfile.rb").and_return(true)
    @task.check_if_test_file_exists("mytestfile").should == "mytestfile"
  end

  it "should detect if the test of interest is working, even if it's missing a _test" do
    File.should_receive(:exist?).with("railsroot/mytestfile.rb").and_return(false)
    File.should_receive(:exist?).with("railsroot/mytestfile_test.rb").and_return(true)
    @task.check_if_test_file_exists("mytestfile").should == "mytestfile_test"
  end

  it "should handle test files that end in .rb" do
    File.should_receive(:exist?).with("railsroot/mytestfile.rb").and_return(true)
    @task.check_if_test_file_exists("mytestfile.rb").should == "mytestfile"
  end

  it "should raise an exception if it can't find any files" do
    File.should_receive(:exist?).with("railsroot/mytestfile.rb").and_return(false)
    File.should_receive(:exist?).with("railsroot/mytestfile_test.rb").and_return(false)
    lambda {@task.check_if_test_file_exists("mytestfile")}.should raise_error(RuntimeError, "Could not find test for mytestfile")
  end

end

describe "A selenium task running run_test_on_servant_browsers" do
  it_should_behave_like "Basic selenium task setup"

  before(:each) do
    @task.stub!(:rake_command).and_return("rakecommand")
  end

  def stub_and_record_run_passing_system_cmd
    @cmd = nil
    @task.should_receive(:run_system_cmd).and_return do |cmd|
      @cmd = cmd
      true
    end
  end

  it "should pass the test name and standard environmental args to the rake task it runs" do
    stub_and_record_run_passing_system_cmd
    @task.run_test_on_servant_browsers("mytest", "localhost")
    @cmd.starts_with?("rakecommand selenium:test_with_server_started --trace test=mytest").should be_true
  end

  it "should pass standard environmental args to the rake task it runs" do
    stub_and_record_run_passing_system_cmd
    @task.run_test_on_servant_browsers("mytest", "localhost")
    @cmd.include?("browsers=firefox").should be_true
    @cmd.include?("selenium_server_host=localhost").should be_true
    @cmd.include?("internal_app_server_host=0.0.0.0").should be_true
    @cmd.include?("external_app_server_host=localhost").should be_true
  end

  it "should allow environment overrides" do
    stub_and_record_run_passing_system_cmd
    @task.env = {"browsers" => "iexplore", "internal_app_server_host" => "foobar", "external_app_server_host" => "foobar"}

    @task.run_test_on_servant_browsers("mytest", "localhost")
    @cmd.include?("browsers=iexplore").should be_true
    @cmd.include?("internal_app_server_host=foobar").should be_true
    @cmd.include?("external_app_server_host=foobar").should be_true
  end

  it "should return false and say an error if the system command returns false" do
    @task.stub!(:run_system_cmd).and_return(false)
    @task.run_test_on_servant_browsers("mytest", "localhost").should be_false
    @sayings.last.should include("SELENIUM FAILURE OCCURRED")
  end
end

describe "A selenium servant_cmd" do
  it_should_behave_like "Basic selenium task setup"

  before(:each) do
    @task.stub!(:rake_command).and_return("rakecommand")
  end

  it "should use the default server jar by default" do
    @task.selenium_server_jar.should == "vendor/plugins/seleniumrc_fu/bin/selenium-server-0-8-1.jar"
    @task.servant_cmd("whatever").should == "rakecommand selenium:run_server selenium_server_jar=vendor/plugins/seleniumrc_fu/bin/selenium-server-0-8-1.jar"
  end

  it "should pass server jars to the rake command" do
    @task.selenium_server_jar = "myserverjar"
    @task.servant_cmd("whatever").should == "rakecommand selenium:run_server selenium_server_jar=myserverjar"
  end
end