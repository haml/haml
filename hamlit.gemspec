# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hamlit/version'

Gem::Specification.new do |spec|
  spec.name          = "hamlit"
  spec.version       = Hamlit::VERSION
  spec.authors       = ["Takashi Kokubun"]
  spec.email         = ["takashikkbn@gmail.com"]
  spec.summary       = %q{High Performance Haml Implementation}
  spec.description   = %q{High Performance Haml Implementation}
  spec.homepage      = "https://github.com/k0kubun/hamlit"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.0.0"

  spec.add_dependency "escape_utils"
  spec.add_dependency "temple", "~> 0.7.6"
  spec.add_dependency "thor"
  spec.add_dependency "tilt"
  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "coffee-script"
  spec.add_development_dependency "erubis"
  spec.add_development_dependency "faml"
  spec.add_development_dependency "haml"
  spec.add_development_dependency "less"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "redcarpet"
  spec.add_development_dependency "rspec", ">= 3"
  spec.add_development_dependency "sass"
  spec.add_development_dependency "slim"
  spec.add_development_dependency "therubyracer"
  spec.add_development_dependency "unindent"
end
