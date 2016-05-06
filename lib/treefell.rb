require 'term/ansicolor'

require 'treefell/version'
require 'treefell/debug_logger'

module Treefell
  def self.debug(namespace=nil, io: $stdout)
    DebugLogger.new(namespace: namespace, io: io)
  end
end
