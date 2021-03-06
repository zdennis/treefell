require 'spec_helper'
require 'stringio'

describe Treefell::DebugLogger do
  subject(:debug_logger){ described_class.new }

  describe '#puts' do
    let(:io){ StringIO.new }
    let(:output){ io.tap(&:rewind).read }

    context 'when no explicit IO provided' do
      before { $stdout = io }
      after { $stdout = STDOUT }

      it 'writes to $stdout by default' do
        debug_logger.puts 'this is a test'
        expect(output).to eq("this is a test\n")
      end
    end

    context 'when explicit IO is provided' do
      subject(:debug_logger){ described_class.new(io: io) }

      it 'writes to the provided IO' do
        debug_logger.puts 'this is a test'
        expect(output).to eq("this is a test\n")
      end
    end

    context 'when a namespace is provided' do
      subject(:debug_logger) do
        described_class.new(namespace: namespace, io: io)
      end
      let(:namespace){ 'foo' }
      let(:message){ 'namespace on my left' }

      it 'prefixes debug messages with a colorized namespace' do
        debug_logger.puts message
        expect(output).to match(/\e\[\d+m#{namespace}\e\[0m #{message}\n/m)
      end

      it 're-uses the same colored namespace for each message' do
        debug_logger.puts 'message 1'
        debug_logger.puts 'message 2'
        debug_logger.puts 'message 3'
        colors = output.scan(/(\e\[\d+m)#{namespace}/).flatten
        expect(colors.uniq.length).to be 1
      end

      it 'uses different colors for each instantiation of the DebugLogger' do
        debug_loggers = [
          described_class.new(namespace: namespace, io: io),
          described_class.new(namespace: namespace, io: io),
          described_class.new(namespace: namespace, io: io)
        ]
        debug_loggers.each { |debug| debug.puts 'message' }
        colors = output.scan(/(\e\[\d+m)#{namespace}/).flatten
        expect(colors.uniq.length).to be 3
      end
    end

    context 'when a filter is provided' do
      let(:io){ StringIO.new }
      let(:output){ io.tap(&:rewind).read }

      it 'writes the message when the filter#call returns true' do
        debug_logger = described_class.new(io: io, filter: proc { true })
        debug_logger.puts 'this is a test'
        expect(output).to eq("this is a test\n")
      end

      it 'does not write the message filter#call returns false' do
        debug_logger = described_class.new(io: io, filter: proc { false })
        debug_logger.puts 'this is a test'
        expect(output).to_not include("this is a test")
      end
    end
  end

  describe '#== equality' do
    it 'is equal to another instance created with no args' do
      debug_logger_1 = described_class.new
      debug_logger_2 = described_class.new
      expect(debug_logger_1).to eq(debug_logger_2)
      expect(debug_logger_2).to eq(debug_logger_1)
    end

    it 'is equal to another instance with equivalent namespace and io' do
      io = StringIO.new
      debug_logger_1 = described_class.new(namespace: 'foo', io: io)
      debug_logger_2 = described_class.new(namespace: 'foo', io: io)
      expect(debug_logger_1).to eq(debug_logger_2)
      expect(debug_logger_2).to eq(debug_logger_1)
    end

    it 'is not equal when the filters are the same object' do
      filter = proc { true }
      debug_logger_1 = described_class.new filter: filter
      debug_logger_2 = described_class.new filter: filter
      expect(debug_logger_1).to eq(debug_logger_2)
      expect(debug_logger_2).to eq(debug_logger_1)
    end

    it 'is not equal when the namespaces differ' do
      debug_logger_1 = described_class.new namespace: 'foo'
      debug_logger_2 = described_class.new
      expect(debug_logger_1).to_not eq(debug_logger_2)
      expect(debug_logger_2).to_not eq(debug_logger_1)
    end

    it 'is not equal when the given io(s) differ' do
      debug_logger_1 = described_class.new io: StringIO.new
      debug_logger_2 = described_class.new io: StringIO.new
      expect(debug_logger_1).to_not eq(debug_logger_2)
      expect(debug_logger_2).to_not eq(debug_logger_1)
    end

    it 'is not equal when the filters differ' do
      debug_logger_1 = described_class.new filter: proc { true }
      debug_logger_2 = described_class.new filter: proc { true }
      expect(debug_logger_1).to_not eq(debug_logger_2)
      expect(debug_logger_2).to_not eq(debug_logger_1)
    end
  end

  describe '#[] - subloggers' do
    subject(:debug_logger) do
      described_class.new(namespace: namespace, io: io)
    end
    let(:namespace){ 'foo' }
    let(:io){ StringIO.new }
    let(:output){ io.tap(&:rewind).read }

    it 'returns a new DebugLogger' do
      expect(debug_logger['bar']).to be_kind_of(self.described_class)
    end

    it 'puts messages thru the top-level DebugLogger' do
      debug_logger['bar'].puts 'hello there!'
      output_without_ansi = ANSIString.new(output).without_ansi
      expect(output_without_ansi).to eq('foo bar hello there!')
    end
  end
end
