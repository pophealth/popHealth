require File.expand_path(File.dirname(__FILE__) + "/../spec_helper")

module JsunitSpecHelper
  TEST_DEFAULT_CONFIG = {
    :web_root => "/RAILS_ROOT/public",
    :logdir => "/RAILS_ROOT/log",

    :path_to_jsunit => "javascripts/jsunit",
    :path_to_test_pages => "javascripts/test-pages",
    :timeout_seconds => 1200,
    :jsunit_master_host => "localhost",
    :jsunit_master_port => 8081,
    :ant => "/RAILS_ROOT/vendor/ant/bin/ant",
    :disable_requirement_checking => true,
    :jsunit_servants => {"servant_1" => {"port" => 8082}, "servant_2" => {"port" => 8082}}
  }

  def new_jsunit_task
    jsunit = Funkytown::JsunitTask.new("railsenv", "railsroot", {"JAVA_HOME" => "javahome"},
      TEST_DEFAULT_CONFIG)
    class << jsunit
      attr_accessor :sayings
      def process(options)
        ProcessStub.new(options[:host], options[:port], options[:name], options[:cmd], options[:logdir])
      end
      def say(msg, options = {})
        @sayings = [] if @sayings.nil?
        @sayings<< msg
      end
      def browser_file_names=(browser_file_names)
        @browser_file_names = browser_file_names
      end
      def result(test_process)
        "cool"
      end
    end
    jsunit.browser_file_names=nil
    jsunit
  end
end

def new_page(filename, path_to_test_pages = "javascripts/test-pages")
  Funkytown::JsunitTestPage.new(filename, path_to_test_pages)
end

def test_missing_test_file
  proc { jsunit.run_test("doesnt_exist_test.html") }.should_raise(ArgumentError)
end

describe "The JsunitTask class" do
  include JsunitSpecHelper
  attr_accessor :jsunit

  before do
    SYSTEM.root = File.dirname(__FILE__) + "/dummy_project"
    @jsunit = new_jsunit_task
  end

  it "generates browser file names" do
    browser = jsunit.browser_file_names  # generates it
    case PLATFORM
    when /linux/i
      browser.include?("start-firefox.sh;").should be_true
      browser.ends_with?("stop-firefox.sh").should be_true
    when /darwin/i
      browser.ends_with?(  "/script/start-firefox-mac.sh;/RAILS_ROOT/public/javascripts/jsunit/bin/mac/stop-firefox.sh").should be_true
    when /mswin32/i
      browser.starts_with?("C:\\Program Files\\Mozilla Firefox\\firefox.exe,").should be_true
      browser.include?("C:\\Program Files\\Internet Explorer\\iexplore.exe").should be_true
    else
      raise "XXX Write me!"
    end
  end

  it "should start servant and test on localhost with a passing test" do
    processes = []
    jsunit.should_receive(:process).any_number_of_times.and_return do |options|
      processes << options
      process = ProcessStub.new
      process.is_running = true
      process
    end

    jsunit.run_test("pass_test.html")
    process_names = processes.collect{|p|p[:name]}
    process_names.should == ["jsunit_servant_servant_1", "jsunit_servant_servant_2", "jsunit_pass_test-#{jsunit.uid}"]

    processes.each do |process|
      process[:logdir].should == JsunitSpecHelper::TEST_DEFAULT_CONFIG[:logdir]
    end
  end

  it "should check servants before running tests" do
    jsunit.should_receive(:check_servants)
    jsunit.run_test
  end

  it "should send the correct command for test_cmd" do
    @jsunit = Funkytown::JsunitTask.new("railsenv", "railsroot", {}, JsunitSpecHelper::TEST_DEFAULT_CONFIG)
    class << @jsunit
      def say(msg, options = {})
      end
    end

    output = @jsunit.test_cmd(new_page("test_me.html"))

    output.should == %Q!    ! +
      %Q!/RAILS_ROOT/vendor/ant/bin/ant -f /RAILS_ROOT/public/javascripts/jsunit/build.xml\n      ! +
      %Q!"-DremoteMachineURLs=http://servant_1:8082,http://servant_2:8082"\n      ! +
      %Q!"-DresourceBase=/RAILS_ROOT/public"\n      ! +
      %Q!-Dport=8081\n      ! +
      %Q!"-Durl=http://localhost:8081/jsunit/javascripts/jsunit/testRunner.html?testPage=http://localhost:8081/jsunit/javascripts/test-pages/test_me.html"\n      ! +
      %Q!"-DlogsDirectory=/RAILS_ROOT/log"\n      ! +
      %Q!distributed_test\n!

  end

  it "should end up with the proper servant_cmd to run JsUnit" do
    cmd = Funkytown::JsunitTask.new("railsenv", "railsroot", {}, JsunitSpecHelper::TEST_DEFAULT_CONFIG).servant_cmd("servant_1")

    cmd.starts_with?(%Q!    ! +
      %Q!/RAILS_ROOT/vendor/ant/bin/ant -f public/javascripts/jsunit/build.xml\n      !).should == true
#    %Q!"-DbrowserFileNames="\n      ! +
    cmd.ends_with?(
      %Q!-Dport=8082\n      ! +
      %Q!-DtimeoutSeconds=1200\n      ! +
      %Q!"-DlogsDirectory=/RAILS_ROOT/log"\n      ! +
      %Q!start_server\n!).should == true
  end

  it "should get the correct arguments into servant_process" do
    process = Funkytown::JsunitTask.new("railsenv", "railsroot", {}, JsunitSpecHelper::TEST_DEFAULT_CONFIG).
      send(:servant_process, "servant_1")

    process.name.should == "jsunit_servant_servant_1"
    process.cmd.include?("ant -f public/javascripts/jsunit/build.xm").should be_true
    process.host.should == "servant_1"
    process.port.should == 8082
    process.logdir.should == "/RAILS_ROOT/log"
  end

  it "test_master_process" do
    @jsunit = Funkytown::JsunitTask.new("railsenv", "railsroot", {}, JsunitSpecHelper::TEST_DEFAULT_CONFIG)
    @jsunit.stub!(:say)
    process = jsunit.master_process(new_page("im_test_page"))

    process.name.should == "jsunit_im_test_page-#{jsunit.uid}"
    process.cmd.include?("?testPage=http://localhost:8081/" +
      "jsunit/javascripts/test-pages/im_test_page").should be_true
    process.host.should == "localhost"
    process.port.should be_nil
    process.logdir.should == "/RAILS_ROOT/log"
  end

  it "test_test_page__name" do
    new_page("foo.html").name.should == "jsunit_foo"
    new_page("sub/foo.html").name.should == "jsunit_sub_foo"
  end

  it "test_test_page__clean" do
    new_page("foo.html").clean.should == "foo.html"
    new_page("javascripts/test-pages/foo.html").clean.should == "foo.html"
    new_page("javascripts/test-pages/sub/foo.html").clean.should == "sub/foo.html"
    new_page("#{SYSTEM.root}/public/javascripts/test-pages/foo.html").clean.should == "foo.html"
  end

  # NOTE: these tests were already commented in unit/jsunit_task_test before we converted to rspec
  # # TODO: ADC - Fix me and think about this!!!
  # def xtest_read_latest_jsunit_result_file
  #   logdir_path = SYSTEM.default_temp_dir + "/jsunit-log"
  #   if File.exist? logdir_path
  #     FileUtils.rm_rf(logdir_path)
  #   end
  #
  #   begin
  #     Dir.mkdir(logdir_path)
  #     Tempfile.open("JSTEST-10000", logdir_path) do |file|
  #       file.puts("<xml>older!!</xml>")
  #     end
  #     Tempfile.open("JSTEST-10002", logdir_path) do |file|
  #       file.puts("<xml>latest!!</xml>")
  #     end
  #     Tempfile.open("JSTEST-10001", logdir_path) do |file|
  #       file.puts("<xml>old!!</xml>")
  #     end
  #
  #     # ask Jsunit object to find the latest one
  #     jsunit = Funkytown::JsunitTask.new({:logdir => logdir_path})
  #
  #     # assert the contents
  #     assert_equal "--- latest!!\n", jsunit.latest_failure
  #   ensure
  #     FileUtils.rm_rf(logdir_path)
  #   end
  # end
  #
  # # TODO: ADC - Fix me and think about this!!!
  # def xtest_test_page__path_and_path_on_disk
  #   testpage = new_page("test_me.html", "javascript/test-pages")
  #   assert_equal "javascript/test-pages/test_me.html", testpage.path
  #   assert testpage.path_on_disk =~ /tracker2.*\/public\/javascript\/test-pages\/test_me.html/
  #
  #   testpage = new_page("suite.html",
  #     "/home/pivotal/dev/workspace/tracker2/public/javascript/test-pages")
  #   assert_equal("/home/pivotal/dev/workspace/tracker2/public/javascript/test-pages/suite.html",
  #     testpage.path)
  # end



end
