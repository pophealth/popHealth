require 'test_helper'

class UserRakeTest < ActiveSupport::TestCase

  @@rake = nil

  setup do

    dump_database
    collection_fixtures 'users', 'providers'

    @unapproved_user = User.where({email: 'unapproved@test.com'}).first
    @user = User.where({email: 'noadmin@test.com'}).first
    @admin = User.where({email: 'admin@test.com'}).first

    if (!@@rake)
      @@rake = Rake.application
      Rake.application = @@rake
      Rake.application.rake_require "../../lib/tasks/popHealth_users"
      Rake::Task.define_task(:environment)
    end
    Rake.application.tasks.each {|t| t.instance_eval{@already_invoked = false}}

  end

  teardown do

  end

  test "approve rake task approves user" do
    assert !@unapproved_user.approved?
    assert !@unapproved_user.admin?

    ENV['USER_ID'] = @unapproved_user.username
    capture_stdout do
      @@rake["pophealth:users:approve"].invoke
    end

    @unapproved_user.reload

    assert @unapproved_user.approved?
    assert !@unapproved_user.admin?

  end

  test "admin rake task approves and grants admin using email" do
    assert !@unapproved_user.approved?
    assert !@unapproved_user.admin?

    ENV['EMAIL'] = @unapproved_user.email
    capture_stdout do
      @@rake["pophealth:users:grant_admin"].invoke
    end

    @unapproved_user.reload

    assert @unapproved_user.approved?
    assert @unapproved_user.admin?

  end

  test "admin rake task makes a non-admin user an admin" do
    assert !@user.admin?

    ENV['USER_ID'] = @user.username
    capture_stdout do
      @@rake["pophealth:users:grant_admin"].invoke
    end

    @user.reload

    assert @user.approved?
    assert @user.admin?

  end

  test "revoke rake task makes a admin user a non-admin" do
    assert @admin.admin?

    ENV['USER_ID'] = @admin.username

    capture_stdout do
      @@rake["pophealth:users:revoke_admin"].invoke
    end

    @admin.reload

    assert @admin.approved?
    assert !@admin.admin?

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
