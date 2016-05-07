require 'spec_helper'

describe Treefell::Filters::EnvFilter do
  subject(:filter){ described_class.new }

  describe '#call' do
    let(:namespace) { 'foobar' }
    let(:message) { 'message' }

    it 'returns false when the namespace is NOT in the specified env var' do
      filter = described_class.new(var_name: 'FOOBARBAZ')
      expect(filter.call(namespace, message)).to eq false
    end

    it 'returns true when the namespace is the value of the env var' do
      filter = described_class.new(var_name: 'FOOBARBAZ')
      ClimateControl.modify FOOBARBAZ: namespace do
        expect(filter.call(namespace, message)).to eq true
      end
    end

    it 'returns true when the namespace is included the env var a part of  a comma separated list of values' do
      filter = described_class.new(var_name: 'FOOBARBAZ')
      ClimateControl.modify FOOBARBAZ: "hrm,#{namespace},baz" do
        expect(filter.call(namespace, message)).to eq true
      end
    end
  end
end
