require 'erb'
require 'yaml'
require 'funkytown/hash_extensions'

module Funkytown
  class FunkytownConfig

    def self.load
      default_config.merge(load_file(default_filename)).merge(load_file(machine_specific_filename))
    end

    def self.load_file(filename)
      if File.exist? filename
        File.open(filename) do |file|
          from_yaml(file.read)
        end
      else
        {}
      end
    end

    def self.from_yaml(yaml_string)
      x = ERB.new(yaml_string).result
      yaml = YAML.load(x.to_s)
      return {} unless yaml.is_a?(Hash)
      yaml.keys_to_symbols
    end

    def self.default_config
      {
      # global
      :logdir => "#{root}/log",
      :fail_if_remote_servants_not_running => false,

      # jsunit
      :jsunit_master_host => "localhost",
      :jsunit_master_port => 8082,
      :path_to_jsunit => "javascripts/jsunit/jsunit",
      :path_to_test_pages => "javascripts/test-pages",
      :timeout_seconds => 1200,
      :web_root => "#{root}/public",
      :jsunit_servants => {
        "localhost" => {
          "port" => 8081,
        }
      },
      :ant => ant,

      # selenium
      :selenium_server_jar => "vendor/plugins/seleniumrc_fu/bin/selenium-server-0-8-1.jar",
      :external_app_server_host => "localhost",
      :external_app_server_port => 4000,
      :internal_app_server_host => "0.0.0.0",
      :internal_app_server_port => 4000,
      :app_server_engine => :webrick,
      :verify_remote_app_server_is_running => true,
      :keep_browser_open_on_failure => false,
      :selenium_servants => {
        "localhost" => {
          "port" => 4444,
          "browsers" => ["firefox"]
        }
      }
      }
    end

    private
    def self.root
      SYSTEM.root
    end

    def self.ant
      if SYSTEM.windows
        "#{root}/vendor/ant/bin/ant.bat".gsub('/', '\\')
      else
        "#{root}/vendor/ant/bin/ant"
      end
    end

    def self.machine_specific_filename
      "#{root}/config/funkytown/#{SYSTEM.hostname}.yml"
    end

    def self.default_filename
      "#{root}/config/funkytown/default.yml"
    end
  end
end