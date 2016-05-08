require 'term/ansicolor'

require 'treefell/version'
require 'treefell/debug_logger'
require 'treefell/filters/env_filter'

module Treefell
  ENV_VAR_LOOKUP = -> { ENV[Treefell.env_var] }

  def self.env_var=(env_var)
    @env_var = env_var
  end

  def self.env_var
    @env_var || Filters::EnvFilter::ENV_VAR_KEY
  end

  def self.debug(namespace=nil, io: $stdout, filter: nil)
    filter ||= Filters::EnvFilter.new(value: ENV_VAR_LOOKUP)
    @debug_loggers ||= {}
    @debug_loggers[namespace] ||= DebugLogger.new(
      namespace: namespace,
      io: io,
      filter: filter
    )
  end

  def self.reset
    @debug_loggers.clear if @debug_loggers
    @env_var = nil
  end

  def self.[](namespace)
    debug(namespace)
  end
end
