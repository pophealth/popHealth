module Selenium
  class SeleneseInterpreter
    attr_reader :server_host, :server_port

    def browser_start_command
      @browserStartCommand
    end

    def browser_url
      @browserURL
    end

    def timeout_in_milliseconds
      @timeout
    end

    alias_method :confirm, :get_confirmation

    def insert_javascript_file(uri)
      js = <<-USEREXTENSIONS
        var headTag = document.getElementsByTagName("head").item(0);
        var scriptTag = document.createElement("script");
        scriptTag.src = "#{uri}";
        headTag.appendChild(scriptTag);
      USEREXTENSIONS
      get_eval(js)
    end
    
    def insert_plugin_javascript(rails_root, file_path)
      if File.exists?(file_path)
        destination = File.join(rails_root + '/public/seleniumrc_fu')
        FileUtils.mkdir_p(destination)
        FileUtils.cp(file_path, destination)
        
        insert_javascript_file("/seleniumrc_fu/#{File.basename(file_path)}")
      end
    end
  end
end
