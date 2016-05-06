lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'treefell/version'

Gem::Specification.new do |s|
  s.name        = 'treefell'
  s.version     = Treefell::VERSION
  s.date        = Time.now.strftime '%Y-%m-%d'
  s.summary     = 'Treefell is a simple debug-logging library for ruby'
  s.description = 'Treefell is a simple debug-logging library for ruby.'
  s.authors     = ['Zach Dennis']
  s.email       = 'zach.dennis@gmail.com'
  s.files       = `git ls-files -z`.split("\x0")
  s.homepage    = 'https://github.com/zdennis/treefell'
  s.license     = 'MIT'

  s.add_dependency "term-ansicolor", "~> 1.3"
  s.add_development_dependency 'rspec', '~> 3.4.0', '>= 3.4'
end
