module SeleniumrcFu
  class MongrelSeleniumServerRunner < SeleniumServerRunner
    def start
      @configurator = @context.create_mongrel_configurator
      initialize_server(@configurator)

      @thread_class.start do
        start_server
      end
      @started = true
    end

    protected
    def start_server
      @configurator.run
      @configurator.log "Mongrel running at #{@context.internal_app_server_host}:#{@context.internal_app_server_port}"
      @configurator.join
    end

    def initialize_server(config)
      config.listener do |*args|
        mongrel = (args.first || self)
        mongrel.log "Starting Rails in environment #{defaults[:environment]} ..."
        mongrel.uri "/", :handler => mongrel.rails
        mongrel.log "Rails loaded."

        mongrel.log "Loading any Rails specific GemPlugins"
        mongrel.load_plugins
      end
    end

    def stop_server
    end
  end
end