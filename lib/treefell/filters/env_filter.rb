module Treefell
  module Filters
    class EnvFilter
      NAMESPACE_ENV_VAR_KEY = 'DEBUG'
      NAMESPACE_ENV_VAR_LOOKUP = -> { ENV[NAMESPACE_ENV_VAR_KEY] }
      WILDCARD = '*'

      def initialize(value: NAMESPACE_ENV_VAR_LOOKUP)
        @value_proc = value
      end

      def call(namespace, message)
        @value = @value_proc.call
        is_mentioned?(namespace)
        is_mentioned?(namespace) || is_mentioned?(WILDCARD)
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.instance_variable_get(:@value_proc) == @value_proc
      end

      private

      def is_mentioned?(str)
        @value.to_s.split(/\s*,\s*/).include?(str)
      end
    end
  end
end
