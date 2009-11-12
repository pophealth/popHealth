dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

module SeleniumRakeTaskFunctionalSpec
  def setup_project
    tmpdir = Dir.tmpdir
    root_dir = "#{tmpdir}/#{Time.now.to_i.to_s}"
    create_root_dir(root_dir)
    create_task(root_dir)
    create_selenium_library_files(root_dir)
    root_dir
  end

  def current_dir
    File.dirname(__FILE__)
  end

  def create_root_dir(root_dir)
    FileUtils.mkdir_p(root_dir)
  end

  def create_task(root_dir)
    selenium_rake_path = "#{current_dir}/../../tasks/selenium.rake"
    loadpath_bootstrap_path = "#{current_dir}/../../tasks/loadpath_bootstrap.rb"
    rakefile_path = "#{root_dir}/Rakefile"
    File.open(rakefile_path, "w") do |f|
      f.puts "RAILS_ROOT = '#{root_dir}'"
      f.puts "RAILS_ENV = 'development'"
      f.puts "require 'rake'"
      f.puts "require 'rake/testtask'"
      f.puts "require 'rake/rdoctask'"
      f.puts "require 'tasks/rails'"
      f.write File.read(selenium_rake_path)
    end
    FileUtils.cp loadpath_bootstrap_path, root_dir + "/loadpath_bootstrap.rb"
  end

  def create_selenium_library_files(root_dir)
    selenium_dir = "#{root_dir}/seleniumrc_fu/tasks"
    FileUtils.mkdir_p selenium_dir
    FileUtils.cp(
      "#{current_dir}/../../lib/seleniumrc_fu/tasks/selenium_test_task.rb",
      "#{selenium_dir}/selenium_test_task.rb"
    )
  end

  def create_passing_selenium_test_suite(root_dir)
    selenium_test_dir = "#{root_dir}/test/selenium"
    FileUtils.mkdir_p selenium_test_dir
    selenium_suite_path = "#{selenium_test_dir}/selenium_suite.rb"
    File.open(selenium_suite_path, "w") do |f|
      f.puts "require 'test/unit'"
    end
  end

  def create_failing_selenium_test_suite(root_dir)
    selenium_test_dir = "#{root_dir}/test/selenium"
    FileUtils.mkdir_p selenium_test_dir
    selenium_suite_path = "#{selenium_test_dir}/selenium_suite.rb"
    File.open(selenium_suite_path, "w") do |f|
      f.puts "require 'test/unit'"
      f.puts "raise 'Foobar'"
    end
  end
end

describe "A test:selenium rake task that succeeds" do
  include SeleniumRakeTaskFunctionalSpec

  if RUBY_PLATFORM =~ /[^r]win/
    warn "Cannot run Selenium Rake functional tests in Windows"
  else
    it "should execute the selenium suite and exit with code 0" do
      root_dir = setup_project
      create_passing_selenium_test_suite(root_dir)

      Dir.chdir(root_dir) do
        cmd = "rake selenium:test_with_server_started"
        open("|#{cmd}") {|exec| exec.read}
        $?.exitstatus.should == 0
      end
    end
  end
end

describe "A test:selenium rake task that fails" do
  include SeleniumRakeTaskFunctionalSpec

  if RUBY_PLATFORM =~ /[^r]win/
    warn "Cannot run Selenium Rake functional tests in Windows"
  else
    it "should execute the selenium suite and exit with code 1" do
      root_dir = setup_project
      create_failing_selenium_test_suite(root_dir)

      Dir.chdir(root_dir) do
        cmd = "rake selenium:test_with_server_started"
        open("|#{cmd}") {|exec| exec.read}
        $?.exitstatus.should == 1
      end
    end
  end
end
