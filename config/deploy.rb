#
# This deploy script is designed to deploy Laika to a configured Amazon EC2
# instance.
#
# To deploy Laika, go to the parent directory and type 'cap deploy'
#

#
# You must specify scm_username, scm_password and server_name in deploy_local.rb.
#
load File.dirname(__FILE__) + '/deploy_local.rb'

#
# In order to automatically authenticate via SSH you must add the correct
# PEM key to your ssh-agent:
#
#  $ ssh-add $YOUR_AMAZON_SSH_PEM_KEY
#
set :ssh_options, { :forward_agent => true }

# FIXME For now, we are deploying to EC2 as the root user.
set :user, 'root'
set :user_sudo, false

# git config
set :scm,         'git'
set :deploy_via,  :remote_cache
set :git_enable_submodules, true

# git repo defaults if they're not set in deploy_local.rb
set :repository, 'git://github.com/CCHIT/laika.git' unless exists? :repository
set :branch,     'master'                           unless exists? :branch

# application-specific configuration
set :application, 'laika'
set :deploy_to,   '/var/www/laika'
set :rails_env,   'production'
set :rake,        '/usr/local/jruby/bin/jruby -S rake'

role :app, server_name
role :web, server_name
role :db,  server_name, :primary => true

namespace :deploy do
  task :stop,    :roles => :app do stop_glassfish end
  task :start,   :roles => :app do start_glassfish end

  desc "Start the WEBrick server"
  task :start_webrick, :roles => :app do
    # XXX can't run as a daemon because jruby won't fork
    run "/usr/local/jruby/bin/jruby #{release_path}/script/server -p 80 -e production &"
  end

  desc "Stop the WEBrick server"
  task :stop_webrick, :roles => :app do
    # XXX ?
  end

  desc "Start the glassfish server"
  task :start_glassfish, :roles => :app do
    run "/usr/local/jruby/bin/jruby -S glassfish_rails -d -e #{rails_env} -p 80 #{current_path}"
  end

  desc "Stop the glassfish server"
  task :stop_glassfish, :roles => :app do
    run "if [ -x #{shared_path}/log/glassfish.pid ]; then kill -s SIGINT `cat #{shared_path}/log/glassfish.pid`; fi"
  end

  task :restart, :roles => :app do stop; start end
end

# these tasks are all automatic and shouldn't need to be called explicitly
namespace :laika do
  after  "deploy:update_code", "laika:copy_production_configuration"
  after  "deploy:setup", "laika:bootstrap_production_configuration"

  configurations = {
    "database.yml"   => "#{shared_path}/config/database.yml",
    "glassfish.yml"   => "#{shared_path}/config/glassfish.yml",
  }

  desc "Copy production configuration files stored on the same remote server"
  task :copy_production_configuration, :roles => :app do
    configurations.each_pair do |file, src|
      run "cp #{src} #{release_path}/config/#{file}"
    end
  end

  desc "Copy configuration templates to the shared server config"
  task :bootstrap_production_configuration, :roles => :app do
    run "mkdir -p #{shared_path}/config"
    configurations.each_pair do |file, dest|
      upload "config/#{file}.template", dest, :via => :scp
    end
  end

  desc "Install the required gem dependencies."
  task :install_gems, :roles => :app do
    run "cd #{current_path} && #{rake} gems:install"
  end
end

namespace :remote do
  desc "Open a screen on the deploy target server."
  task :screen do
    system "ssh -t #{user}@#{server_name} screen"
  end
end


