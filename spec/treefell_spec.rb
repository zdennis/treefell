require 'spec_helper'
require 'stringio'

describe Treefell do
  let(:default_filter) do
    Treefell::Filters::EnvFilter.new(value: Treefell::NAMESPACE_ENV_VAR_LOOKUP)
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

  describe '.namespace_env_var' do
    it 'determines which env var is used to filter messages' do
      ClimateControl.modify FOOBAR: 'baz' do
        expect(Treefell['baz'].filter.call('baz', 'some message')).to be false

        Treefell.namespace_env_var = 'FOOBAR'
        expect(Treefell.namespace_env_var).to eq 'FOOBAR'

        expect(Treefell['baz'].filter.call('baz', 'some message')).to be true
      end
    end
  end

  describe 'redirecting output with an env var' do
    let(:out_file) { 'tmp-out.txt' }

    after(:each) { FileUtils.rm(out_file) if File.exists?(out_file) }

    it 'writes to the file specified by TREEFELL_OUT' do
      ClimateControl.modify TREEFELL_OUT: out_file, DEBUG: '*' do
        Treefell['baz'].puts 'the rainbow is full of color'
        expect(File.read(out_file)).to match /the rainbow is full of color\n/
      end
    end

    it 'writes multiple namespaces to the same file' do
      ClimateControl.modify TREEFELL_OUT: out_file, DEBUG: '*' do
        Treefell['baz'].puts 'the rainbow is full of color'
        Treefell['foo'].puts 'the sky is blue, sometimes gray'
        Treefell['baz'].puts 'the skittles are delicious'
        output = File.read(out_file)
        expect(output).to match /the rainbow.*the sky.*skittles/m
      end
    end
  end

end
