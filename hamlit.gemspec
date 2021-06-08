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

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|sample)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if /java/ === RUBY_PLATFORM
    spec.platform = 'java'
  else
    spec.extensions = ['ext/hamlit/extconf.rb']
    spec.required_ruby_version = '>= 2.1.0'
  end

  spec.add_dependency 'temple', '>= 0.8.2'
  spec.add_dependency 'thor'
  spec.add_dependency 'tilt'

  spec.add_development_dependency 'benchmark_driver'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coffee-script'
  spec.add_development_dependency 'erubi'
  spec.add_development_dependency 'haml', '>= 5'
  spec.add_development_dependency 'less'
  spec.add_development_dependency 'minitest-reporters', '~> 1.1'
  spec.add_development_dependency 'rails', '>= 4.0'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'sass'
  spec.add_development_dependency 'slim'
  spec.add_development_dependency 'string_template'
  spec.add_development_dependency 'unindent'
end
