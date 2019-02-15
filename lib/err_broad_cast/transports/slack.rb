require 'http'


module ErrBroadCast
  module Transports
    class Slack < BaseTransport

      def initialize(options, http_client:  HTTP)
        super(options)

        @http_client = http_client
      end

      def name
        'slack'
      end

      def up_to_level?
        true
      end

      def send(message, options = {})
        opt = @options.merge(options)
        url = opt.delete(:url)
        payload = extract_payload(opt)
        @http_client.post(url, json: payload.merge(text: message))
      end

      def extract_payload(options)
        payload = {}
        payload[:channel] = options[:channel]
        payload[:username] = options[:username] if options[:username]
        payload[:icon_emoji] = options[:icon_emoji] if options[:icon_emoji]

        payload
      end

      private

      def validate_options
        # rubocop:disable Metrics/LineLength
        raise Invalid, 'invalid transport, web hook url missing' if @options[:url].nil?

        # rubocop:enable Metrics/LineLength
        true
      end
    end
  end
end
