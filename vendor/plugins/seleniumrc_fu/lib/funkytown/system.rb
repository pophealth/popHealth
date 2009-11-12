require 'socket'
require 'fileutils'

module Funkytown
  class System
    attr_accessor :unix, :linux, :mac, :windows
    attr_accessor :default_temp_dir, :has_fork, :has_tee
    attr_accessor :hostname

    def initialize
      case PLATFORM
      when /linux/i
        @linux = @unix = true
        @has_fork = true
        @has_tee = true
        @default_temp_dir = "/tmp"

      when /darwin/i
        @mac = @unix = true
        @has_fork = true
        @has_tee = true
        @default_temp_dir = "/tmp"

      when /mswin32/i
        @windows = true
        @has_fork = false
        @has_tee = false
        @default_temp_dir = "c:\\windows\\temp"

      else
        raise "Unknown platform '#{PLATFORM}'"
      end

      @hostname = `hostname`.chomp.gsub(/\.local$/, '')
    end

    def self.consolidate_path(path)
      while path.include?('/../')
        path = path.gsub(/[^\/]+\/\.\.\//, '')
      end
      path
    end

    def say(msg, options = {})
      always_say_it = !options[:when_verbose]
      if (always_say_it || ENV['VERBOSE'])
        puts System.timed(msg)
      end
    end

    def root
      unless @root
        self.root =
        begin
          RAILS_ROOT
        rescue
          File.dirname(__FILE__)
        end
      end
      @root
    end

    def root=(new_root)
      @root = System.consolidate_path(new_root)
    end

    def self.timed(msg)
      "#{Time.now} - #{msg}"
    end

    def self.wait_for(params={})
      timeout = params[:timeout] || 15
      message = params[:message] || "Timeout exceeded"
      begin_time = Time.now
      while (Time.now - begin_time) < timeout
        return if yield
        sleep 0.5
      end
      raise(message + " (after #{timeout} sec)")
    end

    class Process
      @@system = System.new

      attr_reader :name, :cmd, :logdir, :host, :port

      def initialize(options)
        @name = options[:name] || raise("every process needs a name")
        @cmd = clean(options[:cmd]) if options[:cmd]
        @logdir = System.consolidate_path(options[:logdir] || @@system.default_temp_dir)
        @host = options[:host] || "localhost"
        @port = options[:port] || nil
      end

      def clean(s)
        return nil if s.nil?
        s.gsub(/\n/, ' ').gsub(/ +/, ' ').strip
      end

      def say(msg, options = {})
        @@system.say(msg, options)
        logfile.say(msg) unless options[:console_only]
      end

      def is_running?
        say "Checking for server on #{host}:#{port}", :console_only => true  # so as not to clutter logfiles
        begin
          sock = TCPSocket.new(host, port)
          sock.shutdown
          true
        rescue => e
          false
        end
      end

      def logfile
        unless @logfile
          @logfile = LogFile.new(name, logdir)
        end
        @logfile
      end

      # returns true if command succeeded, false if it failed
      def run(in_bg = false)
        say "Running #{name}" + (in_bg ? " in background" : '')
        command_line = cmd
        command_line = command_line + ">>#{logfile} 2>&1" if @@system.unix
        say "Executing: #{command_line.inspect}", :when_verbose => true
        was_ok = system command_line
        error_status = $?.exitstatus
        say "Error #{error_status} returned" if !was_ok
        was_ok
      end

      def run_fancy
        require 'open3'
        say "Running #{name}"
        say "Executing: #{cmd}", :when_verbose => true

        cmd = cmd + "| tee -a #{logfile}" if @system.has_tee

        outstr = errstr = nil
        inp, out, err = Open3.popen3(cmd)
        t1 = Thread.new { outstr = out.read }
        t2 = Thread.new { errstr = err.read }
        # If you want to send to the child's stdin, write to 'inp' here
        inp.close
        t1.join
        t2.join
        say "stdout:\n#{outstr}"
        say "stderr:\n#{errstr}"

        # stdout said: "crw-rw-rw-  1 root  wheel    2,   2 May 10 08:26 /dev/null\n"
        # stderr said: "ls: /nonexistent: No such file or directory\n"
      end

      # start the process running in the background
      def start
        logfile.say("Starting #{name}")

        if @@system.windows
          # Windows
          say "Starting [[#{cmd}]] in window"
          @cmd = "start cmd /C #{cmd}"
          run(true)
        else
          say "Starting [[#{name}]] in background, output to #{logfile}"
          pid = fork { run(true) }
          PidFile.new(name, @logdir).pid = pid
          ::Process.detach(pid)
        end
      end

      def stop
        unless @@system.unix
          say "I just can't stop on this platform (#{PLATFORM})"
          return
        end

        pidfile = PidFile.new(name, logdir)
        if pidfile.exist?
          pid = pidfile.pid
          say "Stopping #{pid}"
          ::Process.kill("HUP", pid)

          pgid = pidfile.pgid
          say "Stopping group #{pgid}"
          ::Process.kill("TERM", -pgid)

          pidfile.delete
          #    Process.wait(pid)
        else
          say "Can't find pid file for #{name} in #{pidfile.filename}"
        end
      end
    end

    class BaseFile

      def initialize(basename, dir)
        @basename = basename
        @dir = dir
      end

      def filename
        File.join(@dir, "#{@basename}.#{suffix}")
      end

      def suffix
        "txt"
      end

      def exist?
        File.exist? filename
      end

      def delete
        File.delete(filename)
      end

      def read
        File.read(filename)
      end
    end

    class LogFile < BaseFile

      def initialize(basename, dir)
        super(basename, dir)
        FileUtils.touch(filename)
        @first_time = true
      end

      def suffix
        "log"
      end

      def say(msg)
        File.open(filename, 'a') do |f|
          if (@first_time)
            f.puts "\n---"
            @first_time = false
          end
          f.puts System.timed(msg)
        end
      end

      def to_s
        filename
      end
    end

    class PidFile < BaseFile
      attr_reader :pid
      attr_reader :pgid

      def initialize(basename, dir)
        super(basename, dir)
        read if exist?
      end

      def suffix
        "pid"
      end

      def pid=(pid)
        File.open(filename, 'w') do |f|
          f.puts pid
          f.puts ::Process.getpgid(pid)
        end
      end

      def read
        File.open(filename) do |f|
          @pid = f.gets.to_i
          @pgid = f.gets.to_i
        end
      end

    end

  end
end

SYSTEM = Funkytown::System.new
