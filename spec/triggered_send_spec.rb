require 'spec_helper.rb'

describe MarketingCloudSDK::TriggeredSend do

  let(:client) { double('MarketingCloudSDK::Client') }
  let(:triggered_send) { described_class.new }

  before do
    triggered_send.client = client
  end

  context '#send' do
    it 'delegates to the client with the right arguments' do
      expect(client).to receive(:soap_post).with('TriggeredSend', [])
      triggered_send.send
    end

    it 'returns a MarketingCloudSDK::TriggeredSendResponse' do
      mock_response = double('MarketingCloudSDK::Response')
      allow(client).to receive(:soap_post).with('TriggeredSend', []).and_return mock_response
      response = triggered_send.send
      expect(response).to be_instance_of(MarketingCloudSDK::TriggeredSendResponse)
      expect(response.__getobj__).to eq mock_response
    end
  end
end
