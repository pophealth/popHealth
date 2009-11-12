require 'funkytown/funkytown_task'
require 'funkytown/jsunit_test_page'

module Funkytown
  class JsunitTask < FunkytownTask

    attr_accessor :jsunit_servants

    def check_requirements
      return if @disable_requirement_checking
      jsunit_path = "#{@web_root}/#{@path_to_jsunit}/testRunner.html"
      raise "HALT: we could not find a JsUnit test runner at #{jsunit_path}.  You can override this configuration option using the path_to_jsunit key in RAILS_ROOT/config/funkytown/default.yml." unless File.exist?(jsunit_path)
      suite_path = "#{@web_root}/#{@path_to_test_pages}/suite.html"
      raise "HALT: we could not find a suite test path at #{suite_path}.  You can override this configuration option using the path_to_test_pages key in RAILS_ROOT/config/funkytown/default.yml." unless File.exist?(suite_path)
      ant_path = "#{@ant}"
      unless File.exist?(@ant)
        which_ant = `which ant`
        if which_ant.include?("ant")
          @ant = which_ant
        else
          raise "HALT: you need ant in order to run this task. Set the 'ant' property in your funkytown config file, or make sure ant is in your PATH."
        end
      end
    end

    def run_test(test_page = nil)
      raise "HALT: you need JAVA_HOME defined and pointing to a valid java install in order to run this task" unless env.key?('JAVA_HOME')

      test_page ||= "suite.html"

      say "running test '#{test_page}'"

      page = JsunitTestPage.new(test_page, @path_to_test_pages)
      raise ArgumentError.new("Missing file #{test_page}") unless File.exist?(page.path_on_disk)

      check_servants

      say "creating master process"

      test = master_process(page)
      say test.cmd, :when_verbose => true
      ok = test.run
      if ok
        say "PASSED #{page.test_page}"
        say result(test)
        return true
      else
        say "FAILED #{page.test_page}"
        say result(test)
        return false
      end
    end

    def servant_name(servant_host)
      "jsunit_servant_#{servant_host}"
    end

    def servant_cmd(servant_host)
      cmd=<<-END
    #{@ant} -f public/#{@path_to_jsunit}/build.xml
      "-DbrowserFileNames=#{browser_file_names}"
      -Dport=#{servant_port(servant_host)}
      -DtimeoutSeconds=#{@timeout_seconds}
      "-DlogsDirectory=#{@logdir}"
      start_server
    END
      cmd
    end

    def servant_port(servant_host)
      raise "Could not find JSUnit servants" if @jsunit_servants.nil?
      raise "Could not find JSUnit servant for #{servant_host}, only found hosts #{servant_hosts.join(',')}"if @jsunit_servants[servant_host].nil?
      @jsunit_servants[servant_host]["port"]
    end

  ############ settings

    attr_reader :uid

    def servant_urls
      servant_hosts.collect { |host|
        "http://#{host}:#{servant_port(host)}"
      }.join(",")
    end

    def servant_hosts
      @jsunit_servants.keys
    end

    def test_cmd(page)
      say "Running test #{page.clean}"

      cmd=<<-END
    #{@ant} -f #{@web_root}/#{@path_to_jsunit}/build.xml
      "-DremoteMachineURLs=#{servant_urls}"
      "-DresourceBase=#{@web_root}"
      -Dport=#{@jsunit_master_port}
      "-Durl=#{master_base}/#{@path_to_jsunit}/testRunner.html?testPage=#{master_base}/#{page.path}"
      "-DlogsDirectory=#{@logdir}"
      distributed_test
      END
      cmd
    end

    def debug?
      env.key?('jsunit_verbose')
    end

    def root
      SYSTEM.root
    end

    def browser_file_names
      # if the user specified browser_file_names in the config file, use it
      return @browser_file_names if @browser_file_names

      script = "#{root}/vendor/plugins/seleniumrc_fu/script"
      jsunit_bin_dir = "#{@web_root}/#{@path_to_jsunit}/bin"

      if SYSTEM.mac
        "#{script}/start-firefox-mac.sh;#{jsunit_bin_dir}/mac/stop-firefox.sh"
      elsif SYSTEM.linux
        "#{script}/unix/start-firefox.sh;#{jsunit_bin_dir}/unix/stop-firefox.sh"
      elsif SYSTEM.windows
        [
        # "C:/Program Files/Mozilla Firefox/firefox.exe;#{jsunit_bin_dir}/winxp/stop-firefox.bat",
        "C:/Program Files/Mozilla Firefox/firefox.exe",
        "C:/Program Files/Internet Explorer/iexplore.exe",
        ].join(",").gsub('/', "\\")
      else
        raise "Don't know what browsers to run in platform #{PLATFORM}"
      end
    end

    def master_base
      "http://#{@jsunit_master_host}:#{@jsunit_master_port}/jsunit"
    end

    def test_name(test_page)
      "#{test_page.name}-#{uid}"
    end

    def master_process(test_page)
      process(
        :name => test_name(test_page),
        :cmd => test_cmd(test_page),
        :logdir => @logdir
      )
    end

  ###### actions

  end
end
