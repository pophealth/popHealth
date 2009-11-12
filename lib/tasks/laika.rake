def find_user(env)
  case
    when env.key?('USER_ID'):
      User.find env['USER_ID']
    when env.key?('EMAIL'):
      User.find_by_email env['EMAIL']
  end
end

namespace :laika do
  desc %{Make an existing Laika user an administrator.
  
You must identify the user by USER_ID or EMAIL:

  $ rake laika:make_admin USER_ID=###
  or
  $ rake laika:make_admin EMAIL=xxx}
  task :make_admin => :environment do
    raise 'must pass USER_ID or EMAIL' unless ENV['USER_ID'] || ENV['EMAIL']
    user = find_user ENV
    raise 'There is no such user.' unless user
    raise "#{user.display_name} is already an administrator." if user.administrator?
    user.grant_admin
    puts "#{user.display_name} is now an administrator"
  end

  desc %{Remove the administrator role from a Laika user.
  
You must identify the user by USER_ID or EMAIL:

  $ rake laika:unmake_admin USER_ID=###
  or
  $ rake laika:unmake_admin EMAIL=xxx}
  task :unmake_admin => :environment do
    raise 'must pass USER_ID or EMAIL' unless ENV['USER_ID'] || ENV['EMAIL']
    user = find_user ENV
    raise 'There is no such user.' unless user
    raise "#{user.display_name} is not an administrator." if not user.administrator?
    user.revoke_admin
    puts "#{user.display_name} is no longer an administrator"
  end
end

