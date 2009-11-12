module SeleniumrcFu
  # The configuration interface. This SeleniumConfiguration acts as a singleton to a SeleniumContext.
  # You can access the SeleniumContext object by calling
  #   SeleniumrcFu::SeleniumContext.instance
  class SeleniumConfiguration
    module ClassMethods
      # The instance of the Singleton SeleniumContext. On its initial call, the initial configuration is set.
      # The initial configuration is based on Environment variables and defaults.
      # The environment variables are:
      # * RAILS_ENV - The Rails environment (defaults: test)
      # * selenium_server_host - The host name for the Selenium RC server (default: localhost)
      # * selenium_server_port - The port for the Selenium RC server (default: 4444)
      # * webrick_host - The host name that the application server will start under (default: localhost)
      # * webrick_port - The port that the application server will start under (default: 4000)
      # * app_server_engine - The type of server the application will be run with (webrick or mongrel)
      # * browsers - A comma-delimited list of browsers that will be tested (e.g. firebox,iexplore)
      # * internal_app_server_host - The host name for the Application server that the Browser will access (default: localhost)
      # * internal_app_server_host - The port for the Application server that the Browser will access (default: 4000)
      # * keep_browser_open_on_failure - If there is a failure in the test suite, keep the browser window open (default: true)
      # * verify_remote_app_server_is_running - Raise an exception if the Application Server is not running (default: true)
      def instance
        return @context if @context
        @context = SeleniumContext.new
        @context.establish_environment(ENV)
        @context
      end
    end
    extend ClassMethods
  end
end