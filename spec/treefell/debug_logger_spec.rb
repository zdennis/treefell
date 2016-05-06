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
  end
end
