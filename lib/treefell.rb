require 'term/ansicolor'

require 'treefell/version'
require 'treefell/debug_logger'
require 'treefell/filters/env_filter'

module Treefell
  NAMESPACE_ENV_VAR_LOOKUP = -> { ENV[Treefell.namespace_env_var] }

  def self.namespace_env_var=(namespace_env_var)
    @namespace_env_var = namespace_env_var
  end

  def self.namespace_env_var
    @namespace_env_var || Filters::EnvFilter::NAMESPACE_ENV_VAR_KEY
  end

  def self.debug(namespace=nil, io: nil, filter: nil)
    io ||= begin
      treefell_out = ENV['TREEFELL_OUT']
      if treefell_out
        @treefell_out_io ||= File.open(treefell_out, 'w+').tap do |io|
          io.sync = true
        end
      else
        $stdout
      end
    end
    filter ||= Filters::EnvFilter.new(value: NAMESPACE_ENV_VAR_LOOKUP)
    @debug_loggers ||= {}
    @debug_loggers[namespace] ||= DebugLogger.new(
      namespace: namespace,
      io: io,
      filter: filter
    )
  end

  def self.reset
    if @treefell_out_io
      @treefell_out_io.close unless @treefell_out_io.closed?
      @treefell_out_io = nil
    end
    @debug_loggers.clear if @debug_loggers
    @namespace_env_var = nil
  end

  def self.[](namespace)
    debug(namespace)
  end
end
