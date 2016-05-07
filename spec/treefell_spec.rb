require 'spec_helper'
require 'stringio'

describe Treefell do

  context '.debug' do
    let(:expected_filter) do
      Treefell::Filters::EnvFilter.new(var_name: 'DEBUG')
    end

    it 'creates and returns a debug logger with no namespace' do
      debug = Treefell.debug
      expect(debug).to eq Treefell::DebugLogger.new(filter: expected_filter)
      expect(debug.filter).to eq expected_filter
    end

    it 'creates and returns a debug logger with a namespace' do
      debug = Treefell.debug('foobar')
      expect(debug).to eq Treefell::DebugLogger.new(
        namespace: 'foobar',
        filter: expected_filter
      )
    end

    it 'creates and returns a debug logger with a custom IO' do
      io = StringIO.new
      debug = Treefell.debug('foobar', io: io)
      expect(debug).to eq Treefell::DebugLogger.new(
        namespace: 'foobar',
        io: io,
        filter: expected_filter
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
  end

end
