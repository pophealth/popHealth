module SeleniumrcFu
  class AppServerChecker

    attr_accessor :tcp_socket_class
    attr_accessor :context

    def is_server_started?
      @host = @context.internal_app_server_host
      @port = @context.internal_app_server_port
      if (@host == '0.0.0.0')
        @host = '127.0.0.1'
      end
      if (@host == '127.0.0.1' || @host == 'localhost')
        return is_started?
      end

      # must be remote
      return true if @context.verify_remote_app_server_is_running == false

      # should be verified
      return true if is_started?
      # is not started but should be verified, so throw exception
      error_message = "The 'verify_remote_app_server_is_running flag' was true, but the server was not accessible at '#{@host}:#{@port}'.  " \
        "You should either start the server, or set the environment variable 'verify_remote_app_server_is_running' to false " \
        "(IF you are SURE that the server is actually running, but just not accessible from this box)."
      raise RuntimeError.new(error_message)
    end

    def is_started?
      begin
        @socket = @tcp_socket_class.new(@host, @port)
      rescue SocketError
        return false
      rescue Errno::EBADF
        return false
      rescue Errno::ECONNREFUSED
        return false
      end
      @socket.close unless @socket.nil?
      return true
    end
  end
end