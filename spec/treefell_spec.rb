require 'spec_helper'
require 'stringio'

describe Treefell do

  context '.debug' do
    it 'creates and returns a debug logger with no namespace' do
      debug = Treefell.debug
      expect(debug).to eq Treefell::DebugLogger.new
      expect(debug.filter).to eq Treefell::Filters::EnvFilter.new
    end

    it 'creates and returns a debug logger with a namespace' do
      debug = Treefell.debug('foobar')
      expect(debug).to eq Treefell::DebugLogger.new(namespace: 'foobar')
    end

    it 'creates and returns a debug logger with a custom IO' do
      io = StringIO.new
      debug = Treefell.debug('foobar', io: io)
      expect(debug).to eq Treefell::DebugLogger.new(namespace: 'foobar', io: io)
    end

    it 'creates and returns a debug logger with a filter' do
      filter = proc { true }
      debug = Treefell.debug('foobar', filter: filter)
      expect(debug).to eq Treefell::DebugLogger.new(namespace: 'foobar', filter: filter)
      expect(debug.filter).to eq filter
    end
  end

end
