module Treefell
  module Filters
    class EnvFilter
      WILDCARD = '*'

      attr_reader :var_name

      def initialize(var_name:)
        @var_name = var_name
      end

      def call(namespace, message)
        value = ENV[@var_name]
        is_mentioned?(namespace)
        is_mentioned?(namespace) || is_mentioned?(WILDCARD)
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.var_name == var_name
      end

      private

      def var_value
        @var_value  ||= ENV[@var_name]
      end

      def is_mentioned?(str)
        var_value.to_s.split(/\s*,\s*/).include?(str)
      end
    end
  end
end
