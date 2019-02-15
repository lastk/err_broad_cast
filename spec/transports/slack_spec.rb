require 'spec_helper'
require 'err_broad_cast/transports/slack'
RSpec.describe ErrBroadCast::Transports::Slack do
  it 'raises an error if api key is missing' do
    # rubocop:disable Metrics/LineLength
    expect { ErrBroadCast::Transports::Slack.new({}) }.to raise_error(ErrBroadCast::Transports::Invalid)
    # rubocop:enable Metrics/LineLength
  end

  it 'sends message to slack' do
    dumb_driver = spy(ErrBroadCast::Transports::Slack)
    url = 'http://dumb.dumb'
    transport = ErrBroadCast::Transports::Slack.new({ url: url, channel: '#random' },
                                                    http_client: dumb_driver)

    msg = 'Olaaaaaahhhhh enfermeiraaaaa'
    transport.send(msg)
    expected_message = { json: { channel: '#random', text: msg } }
    expect(dumb_driver).to have_received(:post).with(url, expected_message)
  end
end
