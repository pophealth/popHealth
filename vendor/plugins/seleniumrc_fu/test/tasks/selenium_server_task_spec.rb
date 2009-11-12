dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A Selenium Server Task running on a Posix OS" do
  before do
    @original_alt_seperator = File::ALT_SEPARATOR
    File.send(:remove_const, :ALT_SEPARATOR)
    File.const_set(:ALT_SEPARATOR, nil)
  end

  after do
    File.send(:remove_const, :ALT_SEPARATOR)
    File.const_set(:ALT_SEPARATOR, @original_alt_seperator)
  end

  it "should run the default server jar if given no args" do
    @task = SeleniumrcFu::Tasks::SeleniumServerTask.new(nil)

    dir = File.dirname(__FILE__)
    selenium_dir = File.expand_path("#{dir}/../../bin")
    expected_cmd = "java -jar #{selenium_dir}/selenium-server-0-8-1.jar -interactive"
    @task.should_receive(:puts).with(expected_cmd)
    @task.should_receive(:system).with(expected_cmd).and_return(true)
    @task.invoke
  end

  it "should allow the server jar to be specified" do
    @task = SeleniumrcFu::Tasks::SeleniumServerTask.new("myserverjar.jar")
    expected_cmd = "java -jar myserverjar.jar -interactive"
    @task.should_receive(:puts).with(expected_cmd)
    @task.should_receive(:system).with(expected_cmd).and_return(true)
    @task.invoke
  end

  it "should allow interactivity to be turned off" do
    @task = SeleniumrcFu::Tasks::SeleniumServerTask.new("myserverjar.jar", false)
    expected_cmd = "java -jar myserverjar.jar"
    @task.should_receive(:puts).with(expected_cmd)
    @task.should_receive(:system).with(expected_cmd).and_return(true)
    @task.invoke
  end
end

describe "A Selenium Server Task running on Windows" do
  before do
    @original_alt_seperator = File::ALT_SEPARATOR
    File.send(:remove_const, :ALT_SEPARATOR)
    File.const_set(:ALT_SEPARATOR, "\\")
  end

  after do
    File.send(:remove_const, :ALT_SEPARATOR)
    File.const_set(:ALT_SEPARATOR, @original_alt_seperator)
  end

  it "should run selenium server jar and get the backslashes right" do
    @task = SeleniumrcFu::Tasks::SeleniumServerTask.new(nil)

    dir = File.dirname(__FILE__)
    selenium_dir = File.expand_path("#{dir}/../../bin")
    jar_path = "#{selenium_dir}/selenium-server-0-8-1.jar".gsub("/", "\\")
    expected_cmd = "java -jar #{jar_path} -interactive"
    @task.should_receive(:puts).with(expected_cmd)
    @task.should_receive(:system).with(expected_cmd).and_return(true)
    @task.invoke
  end
end
