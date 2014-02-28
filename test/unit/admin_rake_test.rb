require 'test_helper'

class AdminRakeTest < ActiveSupport::TestCase
  
  @@rake = nil
  
  setup do
    
    dump_database
    
    if (!@@rake)
      @@rake = Rake.application
      Rake.application = @@rake
      Rake.application.rake_require "../../lib/tasks/admin"
      Rake::Task.define_task(:environment)
    end
    Rake.application.tasks.each {|t| t.instance_eval{@already_invoked = false}}
    
  end
  
  teardown do
    
  end
  
  test "create an admin user" do
    assert User.where(:username => 'pophealth').blank?

    capture_stdout do
      @@rake["admin:create_admin_account"].invoke
    end
    
    @admin = User.where(:username => 'pophealth').first

    assert !@admin.blank?
    assert @admin.approved?, "the created user should be approved"
    assert @admin.admin?, "the created user should be an admin"
  end
    
  def capture_stdout(&block)
    original_stdout = $stdout
    $stdout = StringIO.new
    begin
      yield
    ensure
      $stdout = original_stdout
    end
  end

  
end
