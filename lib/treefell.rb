require 'term/ansicolor'

require 'treefell/version'

require 'treefell/debug_logger'

module Treefell
  def self.debug(namespace=nil)
    DebugLogger.new(namespace: namespace)
  end
end
