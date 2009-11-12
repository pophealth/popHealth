dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A Selenium Test Task in the development environment" do
  before do
    @task = SeleniumrcFu::Tasks::SeleniumTestTask.new("development", @rails_root = "/path/to/rails/root")
  end

  it %{should reset RAILS_ENV to test
            AND require the project's selenium suite
            AND run Test Unit's Autorunner
            AND raise an exception
            WHEN the runner fails
    } do
    original_rails_env = @task.rails_env
    @task.should_receive(:require).with("#{@rails_root}/test/selenium/selenium_suite")
    Test::Unit::AutoRunner.should_receive(:run).and_return(false)

    proc {
      @task.invoke
    }.should raise_error(RuntimeError, "Test failures")
    @task.rails_env.should === original_rails_env
    @task.rails_env.should == "test"
  end

  it %{should reset RAILS_ENV to test
            AND require the project's selenium suite
            AND run Test Unit's Autorunner
            AND not raise an exception
            WHEN the runner passes
    } do
    original_rails_env = @task.rails_env
    @task.should_receive(:require).with("#{@rails_root}/test/selenium/selenium_suite")
    Test::Unit::AutoRunner.should_receive(:run).and_return(true)

    @task.invoke
    @task.rails_env.should === original_rails_env
    @task.rails_env.should == "test"
  end
end
