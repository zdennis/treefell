module Treefell
  module Filters
    class EnvFilter
      attr_reader :var_name

      def initialize(var_name:)
        @var_name = var_name
      end

      def call(namespace, message)
        return true if is_namespace_mentioned_in_env_var?(namespace)
        false
      end

      def ==(other)
        other.is_a?(self.class) &&
          other.var_name == var_name
      end

      private

      def is_namespace_mentioned_in_env_var?(namespace)
        ENV[@var_name].to_s.split(/\s*,\s*/).include?(namespace)
      end
    end
  end
end
