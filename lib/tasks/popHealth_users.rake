namespace :pophealth do
  namespace :users do

    desc %{Grant an existing popHealth user administrator privileges.

    You must identify the user by USER_ID or EMAIL:

    $ rake pophealth:users:grant_admin USER_ID=###
    or
    $ rake pophealth:users:grant_admin EMAIL=xxx}
    task :grant_admin => :environment do
      RakeUserManager.grant_admin ENV
    end

    desc %{Remove the administrator role from an existing popHealth user.

    You must identify the user by USER_ID or EMAIL:

    $ rake pophealth:users:revoke_admin USER_ID=###
    or
    $ rake pophealth:users:revoke_admin EMAIL=xxx}
    task :revoke_admin => :environment do
      RakeUserManager.revoke_admin ENV
    end
    
    desc %{Approve an existing popHealth user.

    You must identify the user by USER_ID or EMAIL:

    $ rake pophealth:users:approve USER_ID=###
    or
    $ rake pophealth:users:approve EMAIL=xxx}
    task :approve => :environment do
      RakeUserManager.approve ENV
    end

    class RakeUserManager
      def self.grant_admin(env)
        user = find_user(env)
        raise "#{user.username} is already an administrator." if user.admin?
        user.approve
        user.grant_admin
        puts "#{user.username} is now an administrator"
      end
      def self.revoke_admin(env)
        user = find_user(env)
        raise "#{user.username} is not an administrator." if not user.admin?
        user.revoke_admin
        puts "#{user.username} is no longer an administrator"
      end
      def self.approve(env)
        user = find_user(env)
        raise "#{user.username} is already approved." if user.approved?
        user.approve
        puts "#{user.username} is now approved"
      end

      private 

      def self.find_user(env)
        raise 'must pass USER_ID or EMAIL' unless env['USER_ID'] || env['EMAIL']
        case
          when env.key?('USER_ID')
            user = User.by_username env['USER_ID']
            raise 'There is no such user with username: ' + env['USER_ID'] unless user
          when env.key?('EMAIL')
            user = User.by_email env['EMAIL']
            raise 'There is no such user with email: ' + env['EMAIL'] unless user
        end
        user
      end
    end


  end
end

