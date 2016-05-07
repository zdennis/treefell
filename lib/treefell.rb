require 'term/ansicolor'

require 'treefell/version'
require 'treefell/debug_logger'
require 'treefell/filters/env_filter'

module Treefell
  DEFAULT_ENV_VAR = 'DEBUG'

  def self.env_var=(env_var)
    @env_var = env_var
  end

  def self.env_var
    @env_var || DEFAULT_ENV_VAR
  end

  def self.debug(namespace=nil, io: $stdout, filter: nil)
    DebugLogger.new(
      namespace: namespace,
      io: io,
      filter: (filter || Filters::EnvFilter.new(var_name: env_var))
    )
  end
end
