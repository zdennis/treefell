require 'treefell/color'

module Treefell
  class DebugLogger
    attr_reader :io, :namespace

    def initialize(namespace: nil, io: $stdout, color: Color.rotate)
      @namespace = namespace
      @io = io
      @color = color
    end

    def puts(message)
      formatted_namespace = if namespace
        @color.colorize(namespace)
      end
      @io.puts [
        formatted_namespace,
        message
      ].compact.join(' ')
    end

    def ==(other)
      other.is_a?(DebugLogger) &&
        other.namespace == namespace &&
        other.io == io
    end
  end
end
