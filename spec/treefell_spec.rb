require 'spec_helper'

describe Treefell do

  context '.debug' do
    it 'creates and returns a debug logger with no namespace' do
      debug = Treefell.debug
      expect(debug).to eq Treefell::DebugLogger.new
    end

    it 'creates and returns a debug logger with a namespace' do
      debug = Treefell.debug('foobar')
      expect(debug).to eq Treefell::DebugLogger.new(namespace: 'foobar')
    end
  end

end
