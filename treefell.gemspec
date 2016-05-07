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
  s.homepage    = 'https://github.com/zdennis/treefell'
  s.license     = 'MIT'

  exclude_files = %w(.travis.yml .rspec .gitignore Gemfile)
  s.files       = (`git ls-files -z`.split("\x0") - exclude_files)
                    .reject { |file| file =~ /^spec\// }
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files  = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ["lib"]

  s.add_dependency "term-ansicolor", "~> 1.3"
  s.add_development_dependency 'rspec', '~> 3.4.0', '>= 3.4'
  s.add_development_dependency 'climate_control', '~> 0.0.3'
end
