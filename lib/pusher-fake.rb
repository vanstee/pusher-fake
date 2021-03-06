require "em-http-request"
require "em-websocket"
require "multi_json"
require "openssl"
require "thin"

require "pusher-fake/channel"
require "pusher-fake/channel/public"
require "pusher-fake/channel/private"
require "pusher-fake/channel/presence"
require "pusher-fake/configuration"
require "pusher-fake/connection"
require "pusher-fake/server"
require "pusher-fake/server/application"
require "pusher-fake/webhook"

module PusherFake
  # The current version string.
  VERSION = "0.6.0"

  # Call this method to modify the defaults.
  #
  # @example
  #   PusherFake.configure do |configuration|
  #     configuration.port = 443
  #   end
  #
  # @yield [Configuration] The current configuration.
  def self.configure
    yield(configuration)
  end

  # @return [Configuration] Current configuration.
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Convenience method for the JS to override the Pusher client host and port.
  #
  # @return [String] JavaScript overriding the Pusher client host and port.
  def self.javascript
    <<-EOS
      Pusher.host    = #{configuration.socket_host.to_json};
      Pusher.ws_port = #{configuration.socket_port.to_json};
    EOS
  end
end
