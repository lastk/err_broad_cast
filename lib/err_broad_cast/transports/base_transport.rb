module ErrBroadCast
  module Transports
    class Invalid < StandardError; end
    class BaseTransport
      def initialize(options)
        @options = options
        validate_options
      end

      def send(message, options); end

      def name
        raise 'You need implement name method'
      end

      def up_to_level?
        raise 'You need implement up_to_level? method'
      end

      private

      def validate_options
        name
        up_to_level?
      end
    end
  end
end
