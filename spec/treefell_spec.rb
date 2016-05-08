require 'spec_helper'
require 'stringio'

describe Treefell do
  let(:default_filter) do
    Treefell::Filters::EnvFilter.new(value: Treefell::ENV_VAR_LOOKUP)
  end

  after(:each) do
    Treefell.reset
  end

  context '.debug' do
    it 'creates and returns a debug logger with no namespace' do
      debug = Treefell.debug
      expect(debug).to eq Treefell::DebugLogger.new(filter: default_filter)
      expect(debug.filter).to eq default_filter
    end

    it 'creates and returns a debug logger with a namespace' do
      debug = Treefell.debug('foobar')
      expect(debug).to eq Treefell::DebugLogger.new(
        namespace: 'foobar',
        filter: default_filter
      )
    end

    it 'creates and returns a debug logger with a custom IO' do
      io = StringIO.new
      debug = Treefell.debug('foobar', io: io)
      expect(debug).to eq Treefell::DebugLogger.new(
        namespace: 'foobar',
        io: io,
        filter: default_filter
      )
    end

    it 'creates and returns a debug logger with a custom filter' do
      custom_filter = proc { true }
      debug = Treefell.debug('foobar', filter: custom_filter)
      expect(debug).to eq Treefell::DebugLogger.new(
        namespace: 'foobar',
        filter: custom_filter
      )
      expect(debug.filter).to eq custom_filter
    end

    it 'returns the same debug logger across invocations with the same namespace' do
      debug_1 = Treefell.debug('foobar')
      debug_2 = Treefell.debug('foobar')
      expect(debug_2).to be debug_1
    end
  end

  describe '#[]' do
    it 'returns a DebugLogger for the namespace' do
      debug = Treefell['foobar']
      expect(debug).to eq Treefell::DebugLogger.new(
        namespace: 'foobar',
        filter: default_filter
      )
    end
  end

end
