require 'spec_helper'

RSpec.describe FuelSDK::Objects::Base do

  let(:object) { FuelSDK::Objects::Base.new }
  subject{ object }

  describe '#properties' do
    it 'is empty by default' do
      expect(object.properties).to be_empty
    end

    it 'returns item in array when item is not an array' do
      object.properties = {'name' => 'value'}
      expect(object.properties).to eq([{'name' => 'value'}])
    end

    it 'returns array when assigned array' do
      object.properties = [{'name' => 'value'}]
      expect(object.properties).to eq([{'name' => 'value'}])
    end
  end

end

RSpec.describe FuelSDK::BounceEvent do
  let(:object) { FuelSDK::BounceEvent.new }
  subject{ object }

  it_behaves_like 'Soap Read Only Object'
  it "has an id of 'BounceEvent'" do
    expect(subject.id).to eql('BounceEvent')
  end
end

RSpec.describe FuelSDK::ClickEvent do
  let(:object) { FuelSDK::ClickEvent.new }
  subject{ object }

  it_behaves_like 'Soap Read Only Object'
  it "has an id of 'ClickEvent'" do
    expect(subject.id).to eql('ClickEvent')
  end
end

RSpec.describe FuelSDK::ContentArea do
  let(:object) { FuelSDK::ContentArea.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'ContentArea'" do
    expect(subject.id).to eql('ContentArea')
  end
end

RSpec.describe FuelSDK::DataFolder do
  let(:object) { FuelSDK::DataFolder.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'DataFolder'" do
    expect(subject.id).to eql('DataFolder')
  end
end

RSpec.describe FuelSDK::Folder do
  let(:object) { FuelSDK::Folder.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'DataFolder'" do
    expect(subject.id).to eql('DataFolder')
  end
end

RSpec.describe FuelSDK::Email do
  let(:object) { FuelSDK::Email.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'Email'" do
    expect(subject.id).to eql('Email')
  end
end

RSpec.describe FuelSDK::List do
  let(:object) { FuelSDK::List.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'List'" do
    expect(subject.id).to eql('List')
  end
end

RSpec.describe FuelSDK::List::Subscriber do
  let(:object) { FuelSDK::List::Subscriber.new }
  subject{ object }

  it_behaves_like 'Soap Read Only Object'
  it "has an id of 'ListSubscriber'" do
    expect(subject.id).to eql('ListSubscriber')
  end
end

RSpec.describe FuelSDK::OpenEvent do
  let(:object) { FuelSDK::OpenEvent.new }
  subject{ object }

  it_behaves_like 'Soap Read Only Object'
  it "has an id of 'OpenEvent'" do
    expect(subject.id).to eql('OpenEvent')
  end
end

RSpec.describe FuelSDK::SentEvent do
  let(:object) { FuelSDK::SentEvent.new }
  subject{ object }

  it_behaves_like 'Soap Read Only Object'
  it "has an id of 'SentEvent'" do
    expect(subject.id).to eql('SentEvent')
  end
end

RSpec.describe FuelSDK::Subscriber do
  let(:object) { FuelSDK::Subscriber.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'Subscriber'" do
    expect(subject.id).to eql('Subscriber')
  end
end

RSpec.describe FuelSDK::DataExtension::Column do
  let(:object) { FuelSDK::DataExtension::Column.new }
  subject{ object }

  it_behaves_like 'Soap Read Only Object'
  it "has an id of 'DataExtensionField'" do
    expect(subject.id).to eql('DataExtensionField')
  end
end

RSpec.describe FuelSDK::DataExtension do
  let(:object) { FuelSDK::DataExtension.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'DataExtension'" do
    expect(subject.id).to eql('DataExtension')
  end
  it { should respond_to :columns= }
  it { should respond_to :fields }
  it { should respond_to :fields= }

  describe '#post' do
    subject {
  		allow(object).to receive_message_chain(:client,:soap_post) do |id, properties|
  			[id, properties]
  		end
  		allow(object).to receive_message_chain(:client,:package_name).and_return(nil)
  		allow(object).to receive_message_chain(:client,:package_folders).and_return(nil)

      object
    }

    # maybe one day will make it smart enough to zip properties and fields if count is same?
    it 'raises an error when it has a list of properties and fields' do
      subject.fields = [{'Name' => 'Name'}]
      subject.properties = [{'Name' => 'Some DE'}, {'Name' => 'Some DE'}]
      expect{subject.post}.to raise_error(
        'Unable to handle muliple DataExtension definitions and a field definition')
    end

    it 'fields must be empty if not nil' do
      subject.fields = []
      subject.properties = [{'Name' => 'Some DE', 'fields' => [{'Name' => 'A field'}]}]
      expect(subject.post).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          }]
        ])
    end

    it 'DataExtension can be created using properties and fields accessors' do
      subject.fields = [{'Name' => 'A field'}]
      subject.properties = {'Name' => 'Some DE'}
      expect(subject.post).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          }]
        ])
    end

    it 'DataExtension fields can be apart of the DataExtention properties' do
      subject.properties = {'Name' => 'Some DE', 'Fields' => {'Field' => [{'Name' => 'A field'}]}}
      expect(subject.post).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          }]
        ])
    end

    it 'List of DataExtension definitions can be passed' do
      subject.properties = [{'Name' => 'Some DE', 'Fields' => {'Field' => [{'Name' => 'A field'}]}},
        {'Name' => 'Another DE', 'Fields' => {'Field' => [{'Name' => 'A second field'}]}}]
      expect(subject.post).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          },{
            'Name' => 'Another DE',
            'Fields' => {
              'Field' => [{'Name' => 'A second field'}]
            }
          }]
        ])
    end

    it 'DataExtension definitions will translate fields entry to correct format' do
      subject.properties = {'Name' => 'Some DE', 'fields' => [{'Name' => 'A field'}]}
      expect(subject.post).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          }]
        ])
    end

    it 'DataExtension definitions will translate columns entry to correct format' do
      subject.properties = {'Name' => 'Some DE', 'columns' => [{'Name' => 'A field'}]}
      expect(subject.post).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          }]
        ])
    end

    it 'supports columns attribute for a single DataExtension definition' do
      subject.columns = [{'Name' => 'A field'}]
      subject.properties = {'Name' => 'Some DE'}
      expect(subject.post).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          }]
        ])
    end

    describe 'fields are defined twice' do
      it 'when defined in properties and by fields' do
        subject.fields = [{'Name' => 'A field'}]
        subject.properties = {'Name' => 'Some DE', 'Fields' => {'Field' => [{'Name' => 'A field'}]}}
        expect{subject.post}.to raise_error 'Fields are defined in too many ways. Please only define once.'
      end
      it 'when defined in properties explicitly and with columns key' do
        subject.properties = {'Name' => 'Some DE',
          'columns' => [{'Name' => 'A fields'}],
          'Fields' => {'Field' => [{'Name' => 'A field'}]
        }}
        expect{subject.post}.to raise_error 'Fields are defined in too many ways. Please only define once.'
      end
      it 'when defined in properties explicitly and with fields key' do
        subject.properties = {'Name' => 'Some DE',
          'fields' => [{'Name' => 'A fields'}],
          'Fields' => {'Field' => [{'Name' => 'A field'}]
        }}
        expect{subject.post}.to raise_error 'Fields are defined in too many ways. Please only define once.'
      end
      it 'when defined in with fields and colums key' do
        subject.properties = {'Name' => 'Some DE',
          'fields' => [{'Name' => 'A fields'}],
          'columns' => [{'Name' => 'A field'}]
        }
        expect{subject.post}.to raise_error 'Fields are defined in too many ways. Please only define once.'
      end
      it 'when defined in with fields key and accessor' do
        subject.fields = [{'Name' => 'A field'}]
        subject.properties = {'Name' => 'Some DE',
          'fields' => [{'Name' => 'A fields'}]
        }
        expect{subject.post}.to raise_error 'Fields are defined in too many ways. Please only define once.'
      end
    end
  end

  describe '#patch' do
    subject {
      allow(object).to receive_message_chain(:client, :soap_patch) do |id, properties|
        [id, properties]
      end

      object
    }

    it 'DataExtension can be created using properties and fields accessors' do
      subject.fields = [{'Name' => 'A field'}]
      subject.properties = {'Name' => 'Some DE'}
      expect(subject.patch).to eq(
        [
          'DataExtension',
          [{
            'Name' => 'Some DE',
            'Fields' => {
              'Field' => [{'Name' => 'A field'}]
            }
          }]
        ])
    end
  end
end

RSpec.describe FuelSDK::DataExtension::Row do
  let(:object) { FuelSDK::DataExtension::Row.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'DataExtensionObject'" do
    expect(subject.id).to eql('DataExtensionObject')
  end
  it { should respond_to :name }
  it { should respond_to :name= }
  it { should respond_to :customer_key }
  it { should respond_to :customer_key= }

  describe '#name' do
    it 'raises error when missing both name and customer key' do
      expect{ subject.name }.to raise_error('Unable to process DataExtension::Row '\
        'request due to missing CustomerKey and Name')
    end

    it 'returns value' do
      subject.name = 'name'
      expect( subject.name ).to eq 'name'
    end
  end

  describe '#customer_key' do
    it 'raises error when missing both name and customer key' do
      expect{ subject.customer_key }.to raise_error('Unable to process DataExtension::Row '\
        'request due to missing CustomerKey and Name')
    end

    it 'returns value' do
      subject.customer_key = 'key'
      expect( subject.customer_key ).to eq 'key'
    end
  end

  describe '#retrieve_required' do
    it 'raises error when missing both name and customer key' do
      expect{ subject.send(:retrieve_required)}.to raise_error('Unable to process DataExtension::Row '\
        'request due to missing CustomerKey and Name')
      expect{ subject.name }.to raise_error('Unable to process DataExtension::Row '\
        'request due to missing CustomerKey and Name')
    end

    it 'updates missing' do
      rsp = instance_double(FuelSDK::SoapResponse)
      allow(rsp).to receive(:results).and_return([{:name => 'Products', :customer_key => 'ProductsKey'}])
      allow(rsp).to receive(:success?).and_return true

      allow(subject).to receive_message_chain(:client,:soap_get).and_return(rsp)
      subject.name = 'Not Nil'

      # this really wouldn't work this way. name shouldn't be updated since its whats being used for filter,
      # but its a good test to show retrieve_required being fired
      expect(subject.name).to eq 'Not Nil' # not fired
      expect(subject.customer_key).to eq 'ProductsKey' # fired... stubbed get returns customer_key and name for update
      expect(subject.name).to eq 'Products' # returned name
    end
  end

  describe '#get' do
    subject {
      allow(object).to receive_message_chain(:client, :soap_get) do |id, properties, filter|
        [id, properties, filter]
      end

      object
    }

    it 'passes id including name to super get' do
      subject.name = 'Justin'
      expect(subject.get).to eq(['DataExtensionObject[Justin]', [], nil])
    end
  end

  describe '#post' do
    subject {
      allow(object).to receive_message_chain(:client, :soap_post) do |id, properties|
        [id, properties]
      end

      object
    }

    it 'raises an error when missing both name and customer key' do
      subject.properties = [{'Name' => 'Some DE'}, {'Name' => 'Some DE'}]
      expect{subject.post}.to raise_error('Unable to process DataExtension::Row ' \
        'request due to missing CustomerKey and Name')
    end

    it 'uses explicitly defined properties' do
      subject.properties = [{'CustomerKey' => 'Subscribers',
        'Properties' => {'Property' => [{'Name' => 'Name', 'Value' => 'Justin'}]}}]
      expect(subject.post).to eq([
        'DataExtensionObject', [{
          'CustomerKey' => 'Subscribers',
          'Properties' => {'Property' => [{'Name' => 'Name', 'Value' => 'Justin'}]}}]
      ])
    end

    it 'inserts customer key into properties when set using accessor' do
      subject.customer_key = 'Subscribers'
      subject.properties = [{'Properties' => {
        'Property' => [{'Name' => 'Name', 'Value' => 'Justin'}]}}]
      expect(subject.post).to eq([
        'DataExtensionObject', [{
          'CustomerKey' => 'Subscribers',
          'Properties' => {'Property' => [{'Name' => 'Name', 'Value' => 'Justin'}]}}]
      ])
    end

    it 'uses name to get customer key for inseration' do
      subject.name = 'Subscribers'

      rsp = instance_double(FuelSDK::SoapResponse)
      allow(rsp).to receive(:results).and_return([{:name => 'Products', :customer_key => 'ProductsKey'}])
      allow(rsp).to receive(:success?).and_return true

      allow(subject).to receive_message_chain(:client, :soap_get).and_return(rsp)
      subject.properties = [{'Properties' => {
        'Property' => [{'Name' => 'Name', 'Value' => 'Justin'}]}}]

      expect(subject.post).to eq([
        'DataExtensionObject', [{
          'CustomerKey' => 'ProductsKey',
          'Properties' => {'Property' => [{'Name' => 'Name', 'Value' => 'Justin'}]}}]
      ])
    end

    it 'correctly formats array property' do
      subject.customer_key = 'Subscribers'

      subject.properties = [{'Name' => 'Justin'}]

      expect(subject.post).to eq([
        'DataExtensionObject', [{
          'CustomerKey' => 'Subscribers',
          'Properties' => {'Property' => [{'Name' => 'Name', 'Value' => 'Justin'}]}}]
      ])
    end
  end
end

# verify backward compats
RSpec.describe ET_Subscriber do

  let(:object) { ET_Subscriber.new }
  subject{ object }

  it_behaves_like 'Soap Object'
  it "has an id of 'Subscriber'" do
    expect(subject.id).to eql('Subscriber')
  end
end
