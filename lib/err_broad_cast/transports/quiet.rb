require 'err_broad_cast/transports/base_transport'

module ErrBroadCast
  module Transports
    class Quiet < BaseTransport
      def send(message, options); end

      def name
        'quiet'
      end

      def up_to_level?
        true
      end
    end
  end
end
