module PusherFake
  module Server
    # Start the WebSocket server.
    def self.start
      EventMachine.run do
        start_web_server
        start_socket_server
      end
    end

    def self.start_socket_server
      EventMachine::WebSocket.start(socket_server_options) do |socket|
        socket.onopen do
          connection = Connection.new(socket)
          connection.establish

          socket.onmessage do |data|
            connection.process(data)
          end
          socket.onclose do
            Channel.remove(connection)
          end
        end
      end
    end

    def self.start_web_server
      Thin::Logging.silent = true
      Thin::Server.start(configuration.web_host, configuration.web_port, Application, daemonize: false)
    end

    private

    def self.configuration
      PusherFake.configuration
    end

    def self.socket_server_options
      { host: configuration.socket_host,
        port: configuration.socket_port }
    end
  end
end
