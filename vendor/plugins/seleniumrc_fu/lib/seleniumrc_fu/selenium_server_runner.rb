module SeleniumrcFu
  class SeleniumServerRunner
    attr_accessor :context, :thread_class
    def initialize
      @started = false
    end

    def start
      @thread_class.start do
        start_server
      end
      @started = true
    end

    def stop
      stop_server
      @started = false
    end

    def started?
      @started
    end

    protected
    def start_server
      raise NotImplementedError.new("this is abstract!")
    end

    def stop_server
      raise NotImplementedError.new("this is abstract!")
    end
  end
end