require 'treefell/color'

module Treefell
  class DebugLogger
    DEFAULT_FILTER_PROC = proc { true }
    attr_reader :filter, :io, :namespace

    def initialize(namespace: nil, io: $stdout, color: Color.rotate, filter: nil)
      @namespace = namespace
      @io = io
      @color = color
      @filter = filter || DEFAULT_FILTER_PROC
    end

    def [](sub_namespace)
      @debug_loggers ||= {}
      @debug_loggers[sub_namespace] ||= DebugLogger.new(
        namespace: sub_namespace,
        io: self,
        filter: DEFAULT_FILTER_PROC
      )
    end

    def puts(message)
      if @filter.call(namespace, message)
        formatted_namespace = if namespace
          @color.colorize(namespace)
        end
        @io.puts [
          formatted_namespace,
          message
        ].compact.join(' ')
      end
    end

    def ==(other)
      other.is_a?(self.class) &&
        other.namespace == namespace &&
        other.io == io &&
        other.filter == filter
    end
  end
end
