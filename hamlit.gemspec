# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hamlit/version'

Gem::Specification.new do |spec|
  spec.name          = 'hamlit'
  spec.version       = Hamlit::VERSION
  spec.authors       = ['Takashi Kokubun']
  spec.email         = ['takashikkbn@gmail.com']

  spec.summary       = %q{High Performance Haml Implementation}
  spec.description   = %q{High Performance Haml Implementation}
  spec.homepage      = 'https://github.com/k0kubun/hamlit'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|hamlit1)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'escape_utils'
  spec.add_dependency 'haml', '>= 4.0', '<= 5.0'
  spec.add_dependency 'temple', '~> 0.7.6'
  spec.add_dependency 'tilt', '~> 2.0'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'coffee-script'
  spec.add_development_dependency 'faml', '>= 0.3.3'
  spec.add_development_dependency 'less'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'rails', '>= 4.0.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'redcarpet'
  spec.add_development_dependency 'sass'
  spec.add_development_dependency 'therubyracer'
  spec.add_development_dependency 'thor', '~> 0.19'
  spec.add_development_dependency 'unindent'
end
