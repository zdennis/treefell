require 'spec_helper'

describe Treefell::Filters::EnvFilter do
  subject(:filter){ described_class.new(var_name: var_name) }
  let(:var_name){ 'FOOBARBAZ' }

  describe '#call' do
    let(:namespace) { 'foobar' }
    let(:message) { 'message' }

    it 'returns false when the namespace is NOT in the specified env var' do
      filter = described_class.new(var_name: var_name)
      expect(filter.call(namespace, message)).to eq false
    end

    it 'returns true when the namespace is the value of the env var' do
      filter = described_class.new(var_name: 'ABCDEFG')
      ClimateControl.modify ABCDEFG: namespace do
        expect(filter.call(namespace, message)).to eq true
      end
    end

    it 'returns true when the namespace is included the env var a part of  a comma separated list of values' do
      ClimateControl.modify FOOBARBAZ: "hrm,#{namespace},baz" do
        expect(filter.call(namespace, message)).to eq true
      end
    end

    it 'returns true when the env var contains the wildcard: *' do
      ClimateControl.modify FOOBARBAZ: "*" do
        expect(filter.call(namespace, message)).to eq true
      end

      ClimateControl.modify FOOBARBAZ: "hrm,*,baz" do
        expect(filter.call(namespace, message)).to eq true
      end
    end
  end
end
