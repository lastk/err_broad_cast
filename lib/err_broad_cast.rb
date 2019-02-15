require 'err_broad_cast/version'
require 'err_broad_cast/logger'
require 'err_broad_cast/transports/quiet'

module ErrBroadCast
  class Error < StandardError; end

  def self.create(level: :info,
                  format: :json,
                  meta: 'ErrBroadCast Logger',
                  transports:)

    Logger.new(level, format, meta, transports)
  end
end
