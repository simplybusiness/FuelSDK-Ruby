require 'spec_helper'

RSpec.describe FuelSDK::Targeting do

  subject { Class.new.new.extend(FuelSDK::Targeting) }

  it { should respond_to(:endpoint) }
  it { should_not respond_to(:endpoint=) }
  it 'should respond to determine_stack' do
    expect(subject.respond_to?(:determine_stack, true)).to eql(true)
  end
  it { should respond_to(:get) }
  it { should respond_to(:post) }
  it { should respond_to(:patch) }
  it { should respond_to(:delete) }
  it { should respond_to(:access_token) }

  describe '#determine_stack' do
    let(:client) { c = Class.new.new.extend(FuelSDK::Targeting)
      allow(c).to receive(:access_token).and_return('open_sesame')
      allow(c).to receive(:get)
        .with('https://www.exacttargetapis.com/platform/v1/endpoints/soap',{'params'=>{'access_token'=>'open_sesame'}})
        .and_return({'url' => 'S#.authentication.target'})
      c
    }
    it 'sets @endpoint' do
      expect(client.send(:determine_stack)).to eq 'S#.authentication.target'
    end
  end

  describe '#endpoint' do
    let(:client) { c = Class.new.new.extend(FuelSDK::Targeting)
      allow(c).to receive(:get).and_return({'url' => 'S#.authentication.target'})
      c
    }

    it 'calls determine_stack to find target' do
      expect(client.endpoint).to eq 'S#.authentication.target'
    end
  end
end
