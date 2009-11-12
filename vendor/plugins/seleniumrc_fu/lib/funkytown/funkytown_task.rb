require 'funkytown/system'
require 'funkytown/funkytown_config'

module Funkytown
  class FunkytownTask
    attr_accessor :rails_env, :rails_root, :env
    attr_accessor :fail_if_remote_servants_not_running

    def initialize(rails_env = RAILS_ENV, rails_root = RAILS_ROOT, env = ENV, options = {})
      @rails_env = rails_env
      @rails_root = rails_root
      @env = env
      @system = SYSTEM
      @uid = Time.now.to_i

  # todo: refactor
  # Load options from host-specific yml file and set as instance vars
      options = FunkytownConfig.load.merge(options)
      options.keys.each do |key|
        instance_variable_set "@#{key}", options[key.to_sym]
      end

      say "Options #{options.to_yaml}", :when_verbose => true

      check_requirements
    end

    def start_servant
      servant = localhost_servant
      if servant.nil?
        say "No local servants found to start"
      else
        run_local_servant(servant)
      end
    end

    def stop_servant
      servant = localhost_servant
      if servant.nil?
        say "No local servants found to stop"
      elsif !servant.is_running?
        say "Servant not running on #{servant.host}:#{servant.port}"
      else
        servant.stop
        System.wait_for {!servant.is_running?}
        say "Servant stopped on #{servant.host}:#{servant.port}"
      end
    end

    def run_local_servant(servant)
      raise "You can't run a non-local servant" unless is_localhost?(servant.host)

      if servant.is_running?
        say "Servant already running on #{servant.host}:#{servant.port}"
      else
        say "Servant not found on #{servant.host}:#{servant.port}"
        if is_localhost?(servant.host)
          say "Launching #{servant.name} on port #{servant.port}"
          servant.start
          System.wait_for {servant.is_running?}
          say "Servant now running on #{servant.host}:#{servant.port}"
        end
      end
    end

    #todo: test
    def result(test)
      out = ''
      result_url = ''
      capturing = false
      File.open(test.logfile.filename).each do |line|
        line.gsub!(/^.*\[junit\] /,'')
        if line =~ /^Testcase: /
          capturing = true
        elsif line =~ /The result log is at/
          capturing = false
          result_url = /http[\S]+/.match(line).to_s
        end
        if capturing
          out = out + line
        end
      end
      say "Result XML: #{result_url}" unless result_url.empty?
      out
    end

    def localhost_servant
      localhost_servant_host.nil? ? nil : servant_process(localhost_servant_host)
    end

    def localhost_servant_host
      servant_hosts.detect {|host| is_localhost?(host)}
    end

    def is_localhost?(host)
      host == Socket.gethostname.downcase.chomp || host == "localhost" || host == "127.0.0.1"
    end

#    def latest_failure
#      results = Dir.glob("#{@logdir}/JSTEST-*")
#      latest = results.sort.last
#      XmlSimple.new.xml_in(latest).to_yaml
#    end

    def check_servants
      servant_hosts.each do |servant_host|
        say "checking #{servant_host}"
        check_servant(servant_host)
      end
      say "done checking"
    end

    def check_servant(servant_host)
      servant = servant_process(servant_host)
      if !servant.is_running?
        if is_localhost?(servant_host)
          run_local_servant(servant)
        elsif @fail_if_remote_servants_not_running
          raise "Servant not found on #{servant_host}"
        else
          say "Warning: Servant not found on #{servant_host}"
          servant_hosts.delete(servant_host)
        end
      end
    end

    protected

    def servant_process(servant_host)
      process({
        :name => servant_name(servant_host),
        :cmd => servant_cmd(servant_host),
        :host => servant_host,
        :port => servant_port(servant_host),
        :logdir => @logdir
      })
    end

    def check_requirements
      raise NotImplementedError.new("this is abstract!")
    end

    def servant_hosts
      raise NotImplementedError.new("this is abstract!")
    end

    def servant_name(host)
      raise NotImplementedError.new("this is abstract!")
    end

    def servant_port(host)
      raise NotImplementedError.new("this is abstract!")
    end

    def servant_cmd(host)
      raise NotImplementedError.new("this is abstract!")
    end

    def say(msg, options = {})
      SYSTEM.say(msg, options)
    end

    def process(options)
      say "creating process #{options.inspect}" if debug?
      System::Process.new(options)
    end

  end
end