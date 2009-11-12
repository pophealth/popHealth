require File.expand_path(File.dirname(__FILE__) + "/spec_helper")
require 'funkytown/system'

module Funkytown
describe System do
  it "test_initialize" do
    system = Funkytown::System.new
    case PLATFORM
    when /linux/i
      system.unix.should be_true
      system.linux.should be_true
      system.mac.should_not be_true
      system.windows.should_not be_true
      system.default_temp_dir.should == "/tmp"
      system.has_fork.should be_true
      system.has_tee.should be_true
    when /darwin/i
        system.unix.should be_true
        system.linux.should_not be_true
        system.mac.should be_true
        system.windows.should_not be_true
        system.default_temp_dir.should == "/tmp"
        system.has_fork.should be_true
        system.has_tee.should be_true
    when /mswin32/i
      system.unix.should_not be_true
      system.linux.should_not be_true
      system.mac.should_not be_true
      system.windows.should be_true
      system.default_temp_dir.should == "c:\\windows\\temp"
      system.has_fork.should_not be_true
      system.has_tee.should_not be_true
    else
      fail "XXX Write me!"
    end
  end

  it "test_consolidate_path" do
    Funkytown::System.consolidate_path("foo").should == "foo"
    Funkytown::System.consolidate_path("foo/bar").should == "foo/bar"
    Funkytown::System.consolidate_path("foo/bar/baz").should == "foo/bar/baz"
    Funkytown::System.consolidate_path("foo/../bar").should == "bar"
    Funkytown::System.consolidate_path("foo/bar/../baz").should == "foo/baz"
    Funkytown::System.consolidate_path("foo/bar/../../baz").should == "baz"
    Funkytown::System.consolidate_path("../foo").should == "../foo"
    #todo: ../s in different parts of the path
  end

  it "test_process__with_nothing" do
    begin
      Funkytown::System::Process.new({})
    rescue => error
      error.message.should == "every process needs a name"
    end
  end

  it "test_process__name_and_command" do
    process = Funkytown::System::Process.new(:name => "eating", :cmd => "/usr/bin/eat cheese")
    process.name.should == "eating"
    process.cmd.should == "/usr/bin/eat cheese"
  end

  it "test_process__cmd" do
    process = Funkytown::System::Process.new(:name => "fleas", :cmd => "   my   dog\n   has \nfleas   ")
    process.cmd.should == "my dog has fleas"
  end

  it "test_log_file__create_on_first_log" do
    log = Funkytown::System::LogFile.new("eating", SYSTEM.default_temp_dir)
    begin
      log.filename.should match(/log$/)
      log.say("foo")
      log.exist?.should be_true
    ensure
      log.delete
    end
  end

  it "test_is_running" do
    macho = Funkytown::System::Process.new(:name => "macho", :host => "localhost", :port => 9999)

    # silence log output
    class << macho
      def say(message, options = {})
      end
    end

    macho.is_running?.should_not be_true
    # todo: use TCPServer and threads to start a socket listener and
    # macho is running.should be_true
  end


end
end
