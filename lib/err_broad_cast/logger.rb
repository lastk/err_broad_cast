require 'pry'
module ErrBroadCast
  class Logger
    def initialize(level, format, meta, transports)
      raise Error, 'you need pass some transports' if transports.nil?

      @level = level
      @format = format
      @meta = meta
      @transports = Array(transports)

      raise Error, 'transports cant be empty' if @transports.empty?
    end

    def log(message, options = {})
      level = options.fetch(:level, @level)
      format = options.fetch(:format, @format)
      names = options.fetch(:transports, [])
      find_transports(level, format, names).each do |transport|
        transport.send(message, options)
      end
    end

    # aliases

    def info(message, options = {})
      log(message, options.merge(level: :info))
    end

    def debug(message, options = {})
      log(message, options.merge(level: :debug))
    end

    def error(message, options = {})
      log(message, options.merge(level: :error))
    end

    private

    # TODO implement search for all of those
    def find_transports(level, format, names)
      transport_names = Array(names)
      # rubocop:disable LineLength
      transports = @transports.select { |t| (t.up_to_level? level) && (t.format == format) }
      # rubocop:enable LineLength
      return transports if Array(names).empty?

      transports.select { |t| transport_names.include?(t.name) }
    end
  end
end
