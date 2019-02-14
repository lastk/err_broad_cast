require 'err_broad_cast/version'
require 'err_broad_cast/logger'

module ErrBroadCast
  class Error < StandardError; end

  def self.create(level: :info,
                  format: :json,
                  meta: 'ErrBroadCast Logger',
                  transports:)

    Logger.new(level, format, meta, transports)
  end
end
