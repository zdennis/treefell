require 'spec_helper'

describe Treefell::Filters::EnvFilter do
  subject(:filter){ described_class.new }

  describe '#call' do
    let(:namespace) { 'foobar' }
    let(:message) { 'message' }

    context 'defaults' do
      it 'returns false when the namespace is not in the env var' do
        ClimateControl.modify DEBUG: 'nope,not,in,here' do
          expect(filter.call(namespace, message)).to eq false
        end
      end

      it 'returns true when the namespace is in the env var' do
        ClimateControl.modify DEBUG: namespace do
          expect(filter.call(namespace, message)).to eq true
        end
      end

      it 'returns true when the namespace is included in a comma separated list of values' do
        ClimateControl.modify DEBUG: "hrm,#{namespace},baz" do
          expect(filter.call(namespace, message)).to eq true
        end
      end

      it 'returns true when the env var contains the wildcard: *' do
        ClimateControl.modify DEBUG: "*" do
          expect(filter.call(namespace, message)).to eq true
        end

        ClimateControl.modify DEBUG: "hrm,*,baz" do
          expect(filter.call(namespace, message)).to eq true
        end
      end
    end

    context 'providing a custom value lookup' do
      it 'returns true when the namespace is found in the return value of the lookup proc' do
        filter = described_class.new(value: -> { namespace })
        ClimateControl.modify DEBUG: namespace do
          expect(filter.call(namespace, message)).to eq true
        end
      end

      it 'returns true when the namespace is found in the return value of the lookup proc' do
        filter = described_class.new(value: -> { nil })
        ClimateControl.modify DEBUG: namespace do
          expect(filter.call(namespace, message)).to eq false
        end
      end

      it 'calls the lookup proc each time allowing for the filter to change' do
        value = 'a'

        filter = described_class.new(value: -> { value.succ! })
        ClimateControl.modify DEBUG: namespace do
          expect(filter.call('b', message)).to eq true
        end

        ClimateControl.modify DEBUG: namespace do
          expect(filter.call('c', message)).to eq true
        end

        ClimateControl.modify DEBUG: namespace do
          expect(filter.call('d', message)).to eq true
        end
      end
    end
  end
end
