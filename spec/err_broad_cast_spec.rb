# rubocop:disable Metrics/BlockLength
# rubocop:disable Metrics/LineLength
RSpec.describe ErrBroadCast do
  it 'has a version number' do
    expect(ErrBroadCast::VERSION).not_to be nil
  end

  context 'creating loggers' do
    before do
      @dumb_transport = double
      @some_message = 'Hello world!'
    end
    it 'setup logger with some transports' do
      logger = ErrBroadCast.create(level: :info,
                                   format: :json,
                                   meta: 'Err-Storm logger',
                                   transports: @dumb_transport)

      allow(@dumb_transport).to receive(:send).with(@some_message, {})
      # send to all transports
      allow(@dumb_transport).to receive(:up_to_level?).with(:info).and_return(true)
      allow(@dumb_transport).to receive(:format).and_return(:json)
      logger.log(@some_message)
      expect(@dumb_transport).to have_received(:send).with(@some_message, {})
    end

    it 'sends messages to transports based on its name' do
      msg = 'Hello slack'
      logger = ErrBroadCast.create(level: :info,
                                   format: :json,
                                   meta: 'test logger',
                                   transports: @dumb_transport)

      allow(@dumb_transport).to receive(:format).and_return(:json)
      allow(@dumb_transport).to receive(:up_to_level?).with(:info).and_return(true)
      allow(@dumb_transport).to receive(:name).and_return('slack')
      allow(@dumb_transport).to receive(:send).with(msg, transports: 'slack')

      logger.log(msg, transports: 'slack')

      expect(@dumb_transport).to have_received(:send).with(msg, transports: 'slack')
    end

    it 'sends message based on transport level' do
      quiet_guy = spy('Transport')
      logger = ErrBroadCast.create(level: :info,
                                   format: :json,
                                   meta: 'test logger',
                                   transports: [@dumb_transport, quiet_guy])
      msg = 'Yooo!'

      allow(@dumb_transport).to receive(:format).and_return(:json)
      allow(@dumb_transport).to receive(:up_to_level?).with(:debug).and_return(true)
      allow(@dumb_transport).to receive(:name).and_return('slack')
      allow(@dumb_transport).to receive(:send).with(msg, level: :debug)

      logger.debug(msg)
      expect(quiet_guy).to_not receive(:send)
    end
  end
end
# rubocop:enable Metrics/BlockLength
# rubocop:enable Metrics/LineLength
